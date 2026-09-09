Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553F0579837;
	Wed,  9 Sep 2026 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963398; cv=none; b=ENxo/lWixmlxlXjwiNcNNwfdr392+oQt2lO/d3sR+W7Aqvo3/j/utjXY5Clf77H4haM6fjOvStS7reoOcdbDA0FA4SRusySYqvwPM9Opj/7YdF/1Z+y6JdAw/Cv00y8kEqZsJmUkjsE+FPbGkkp23BfWCpL8ZSNYLqbG86m+RRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963398; c=relaxed/simple;
	bh=+ybBZwz24Yup2ly4ai6B8Q/p6p2p2ERbR4UaF1JfmIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usPdG4YJfmqlR4hZRdjpSHQqUsaSaodLW4Ag0e6ijwJYYenUgrWHVsWl3fJw4pH246ervQT5yEbuLI4nEKkJMT5J5G4+Yr7VtUFx9qV/4k0r7LlZUUEAsi/Moui57FRWUKv9+NZxL70roURAyRhSpDJldi6hjo9hISfpdP8aCaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJN0MswA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJN0MswA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC43E1F00A3A;
	Wed,  9 Sep 2026 14:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963397;
	bh=I5cSt1Sc4Iqq/aDbn1u+/9Le/haPHqU39knDo5wfw9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJN0MswAYRthliM2az020lr1vhN6Hxg1i9w+NYi8KXb2+uzqpdfqbF2YZb+mP5r5A
	 9g0f16FOw6gRS6zbNzV4lpJofrXh6IJuUxGWx9JfxPIQKKOLz4Pa278ohWp3VkkDm8
	 4C7BshXEmuGL0qwqGVQvIqSzcVTIMuxuXvFzBOvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shen Yongchao <grayhat@foxmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 064/583] HID: bpf: serialize device reference release in struct_ops destroy path
Date: Wed,  9 Sep 2026 15:35:49 +0200
Message-ID: <20260909134240.278656831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shen Yongchao <grayhat@foxmail.com>

commit 9cdc7e6dc7a99ad7311ad5e7c145f2b9ce4e24b0 upstream.

__hid_bpf_ops_destroy_device() and hid_bpf_unreg() can race on the
same registration reference, double-putting struct hid_device and
freeing it while hid_destroy_device() still uses it.  Serialize the
remove/NULL decision under hdev->bpf.prog_list_lock so exactly one
path releases each registration reference: unreg re-checks ops->hdev
under the lock and returns without putting when the destroy path
already cleared it; all put_device() calls happen after the lock is
dropped, which is safe because a concurrent unreg then observes
ops->hdev == NULL under the lock.

Background: each successful attach (hid_bpf_ops_reg) acquires one
device reference (hid_get_device()).  Two paths can release it:

- device destruction: hid_destroy_device() -> hid_bpf_destroy_device()
  -> __hid_bpf_ops_destroy_device(), which walks hdev->bpf.prog_list
  under rcu_read_lock() and drops one reference per attached program;
- BPF link release: bpf map delete (no BPF_F_LINK) synchronously calls
  st_ops->unreg() -> hid_bpf_unreg(), which drops the reference for
  its own registration.

The coordination handshake (e->hdev = NULL on the destroy side vs
"if (!hdev) return" on the unreg side) is a TOCTOU check: the two
paths run under different lock domains (rcu_read_lock vs
prog_list_lock), so a concurrent unreg can read ops->hdev as
non-NULL, block on prog_list_lock, and then proceed while the
destroy traversal executes - both paths then drop the same
reference.  The refcount reaches zero legitimately (each decrement
is individually valid), so no refcount_t saturation fires: the
device is simply freed while the transport is still inside
hid_destroy_device(), and subsequent teardown touches freed memory.

The fix serializes the remove/NULL decision under prog_list_lock on
both sides and moves the destroy-side puts outside the lock.  With
the lock held, plain reads/writes of ops->hdev are sufficient; no
READ_ONCE/WRITE_ONCE are added, keeping the patch minimal.

Unlocked-read safety: the unlocked read of ops->hdev at the top of
hid_bpf_unreg() cannot touch a freed device, because the unreg path
itself still holds this registration's reference (released only by
its own hid_put_device() after the lock is dropped), and a destroy
traversal that already cleared ops->hdev makes the lock-internal
re-check return early without any put.  At most one of the two
paths releases each registration reference.

Fixes: ebc0d8093e8c ("HID: bpf: implement HID-BPF through bpf_struct_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Shen Yongchao <grayhat@foxmail.com>
Assisted-by: Hermes:kimi-k3
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/bpf/hid_bpf_struct_ops.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/hid/bpf/hid_bpf_struct_ops.c
+++ b/drivers/hid/bpf/hid_bpf_struct_ops.c
@@ -250,6 +250,11 @@ static void hid_bpf_unreg(void *kdata, s
 
 	mutex_lock(&hdev->bpf.prog_list_lock);
 
+	if (!ops->hdev) {
+		mutex_unlock(&hdev->bpf.prog_list_lock);
+		return;
+	}
+
 	list_del_rcu(&ops->list);
 	synchronize_srcu(&hdev->bpf.srcu);
 	ops->hdev = NULL;
@@ -310,13 +315,17 @@ static struct bpf_struct_ops bpf_hid_bpf
 void __hid_bpf_ops_destroy_device(struct hid_device *hdev)
 {
 	struct hid_bpf_ops *e;
+	int count = 0;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(e, &hdev->bpf.prog_list, list) {
-		hid_put_device(hdev);
+	mutex_lock(&hdev->bpf.prog_list_lock);
+	list_for_each_entry(e, &hdev->bpf.prog_list, list) {
 		e->hdev = NULL;
+		count++;
 	}
-	rcu_read_unlock();
+	mutex_unlock(&hdev->bpf.prog_list_lock);
+
+	while (count--)
+		hid_put_device(hdev);
 }
 
 static int __init hid_bpf_struct_ops_init(void)


