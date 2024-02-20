Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC1114A4E6;
	Tue, 20 Feb 2024 21:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464619; cv=none; b=LypWRV6H3LB7KaiCAkYZRKZK8iCj6aNEBl6acufdVxKsnXlmARnSpr9I9sfdcRYQaBpZuUqAsfLzz73iFkGVlS2UPEcsWww/psjpFAKKLZk0BPAL8Yka0d0y7xrEQXVC70wUHiNS28xG9IDtRLcNAlrnx3dK760TRoJ/Gl+KDeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464619; c=relaxed/simple;
	bh=NERTYbzESyi+a/2f7FC93zj0JG3p9bB5stCWSUMadr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bk+QKrx9qd6aSPsGnpWv2tLUxFZNJOKMLyN6aqov41sU5hZ9wdjWszr68ZLc7R7spqbeXuk5IF3mE0JpFK29qx3mS218xHHpE+v49Ul+gbAEThJ9hb5yUU482eWvQvsWJ/5s4bQ2LpRCcxpCJj97HovbSbc7Av/3NNFYNOEZdl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaYKb+jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaYKb+jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079B3C433C7;
	Tue, 20 Feb 2024 21:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464619;
	bh=NERTYbzESyi+a/2f7FC93zj0JG3p9bB5stCWSUMadr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaYKb+jqsqwH2sAEsaCuZFoGZcODRMPzchPp4fB9sNn2yZg0XIvreXAQPuVrsYWXm
	 sJjMYYDRw/UbMVKklLfb2Lpj3xCuUiJExmVZE6syci0JeA2+VscrgjJEBSzs8jykHX
	 iwgD6YmckOlXm47SRLCSU4jpxkrGCfoei55Nne9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.7 082/309] HID: bpf: actually free hdev memory after attaching a HID-BPF program
Date: Tue, 20 Feb 2024 21:54:01 +0100
Message-ID: <20240220205635.759526049@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit 89be8aa5b0ecb3b729c7bcff64bb2af7921fec63 upstream.

Turns out that I got my reference counts wrong and each successful
bus_find_device() actually calls get_device(), and we need to manually
call put_device().

Ensure each bus_find_device() gets a matching put_device() when releasing
the bpf programs and fix all the error paths.

Cc: <stable@vger.kernel.org>
Fixes: f5c27da4e3c8 ("HID: initial BPF implementation")
Link: https://lore.kernel.org/r/20240124-b4-hid-bpf-fixes-v2-2-052520b1e5e6@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/bpf/hid_bpf_dispatch.c  |   29 +++++++++++++++++++++++------
 drivers/hid/bpf/hid_bpf_jmp_table.c |   20 +++++++++++++++++---
 2 files changed, 40 insertions(+), 9 deletions(-)

--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -292,7 +292,7 @@ hid_bpf_attach_prog(unsigned int hid_id,
 	struct hid_device *hdev;
 	struct bpf_prog *prog;
 	struct device *dev;
-	int fd;
+	int err, fd;
 
 	if (!hid_bpf_ops)
 		return -EINVAL;
@@ -311,14 +311,24 @@ hid_bpf_attach_prog(unsigned int hid_id,
 	 * on errors or when it'll be detached
 	 */
 	prog = bpf_prog_get(prog_fd);
-	if (IS_ERR(prog))
-		return PTR_ERR(prog);
+	if (IS_ERR(prog)) {
+		err = PTR_ERR(prog);
+		goto out_dev_put;
+	}
 
 	fd = do_hid_bpf_attach_prog(hdev, prog_fd, prog, flags);
-	if (fd < 0)
-		bpf_prog_put(prog);
+	if (fd < 0) {
+		err = fd;
+		goto out_prog_put;
+	}
 
 	return fd;
+
+ out_prog_put:
+	bpf_prog_put(prog);
+ out_dev_put:
+	put_device(dev);
+	return err;
 }
 
 /**
@@ -345,8 +355,10 @@ hid_bpf_allocate_context(unsigned int hi
 	hdev = to_hid_device(dev);
 
 	ctx_kern = kzalloc(sizeof(*ctx_kern), GFP_KERNEL);
-	if (!ctx_kern)
+	if (!ctx_kern) {
+		put_device(dev);
 		return NULL;
+	}
 
 	ctx_kern->ctx.hid = hdev;
 
@@ -363,10 +375,15 @@ noinline void
 hid_bpf_release_context(struct hid_bpf_ctx *ctx)
 {
 	struct hid_bpf_ctx_kern *ctx_kern;
+	struct hid_device *hid;
 
 	ctx_kern = container_of(ctx, struct hid_bpf_ctx_kern, ctx);
+	hid = (struct hid_device *)ctx_kern->ctx.hid; /* ignore const */
 
 	kfree(ctx_kern);
+
+	/* get_device() is called by bus_find_device() */
+	put_device(&hid->dev);
 }
 
 /**
--- a/drivers/hid/bpf/hid_bpf_jmp_table.c
+++ b/drivers/hid/bpf/hid_bpf_jmp_table.c
@@ -196,6 +196,7 @@ static void __hid_bpf_do_release_prog(in
 static void hid_bpf_release_progs(struct work_struct *work)
 {
 	int i, j, n, map_fd = -1;
+	bool hdev_destroyed;
 
 	if (!jmp_table.map)
 		return;
@@ -220,6 +221,12 @@ static void hid_bpf_release_progs(struct
 		if (entry->hdev) {
 			hdev = entry->hdev;
 			type = entry->type;
+			/*
+			 * hdev is still valid, even if we are called after hid_destroy_device():
+			 * when hid_bpf_attach() gets called, it takes a ref on the dev through
+			 * bus_find_device()
+			 */
+			hdev_destroyed = hdev->bpf.destroyed;
 
 			hid_bpf_populate_hdev(hdev, type);
 
@@ -232,12 +239,19 @@ static void hid_bpf_release_progs(struct
 				if (test_bit(next->idx, jmp_table.enabled))
 					continue;
 
-				if (next->hdev == hdev && next->type == type)
+				if (next->hdev == hdev && next->type == type) {
+					/*
+					 * clear the hdev reference and decrement the device ref
+					 * that was taken during bus_find_device() while calling
+					 * hid_bpf_attach()
+					 */
 					next->hdev = NULL;
+					put_device(&hdev->dev);
+				}
 			}
 
-			/* if type was rdesc fixup, reconnect device */
-			if (type == HID_BPF_PROG_TYPE_RDESC_FIXUP)
+			/* if type was rdesc fixup and the device is not gone, reconnect device */
+			if (type == HID_BPF_PROG_TYPE_RDESC_FIXUP && !hdev_destroyed)
 				hid_bpf_reconnect(hdev);
 		}
 	}


