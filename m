Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831516;
	b=YVwWh0FSKnJh5x4JaYmlu6Qy/IQqkZPcrXULv3Jv4vQNHAL/Ra64Q2JD9QoHcaujm/oC
	 +rAgBETFMd7b2Fiv7m3Op8IGo3SSC577dLGda/fMgOQx6uRV1QdD55fFEl0U2h3X492Up
	 Cw0JN20RXogRMydpLfa1QZB0h98B0XoasWwnX1AsIYLxbXjo9fB/nnRqwZ9fHu3iOSRjm
	 fSWKcRlS/BoXz2Bx/BUwM+3tO+2+VCdRqlVbie/CpDNbZzaKNTz9wUgO6ISx+myq1fvZU
	 1J5XQGJBEu4SVi66rzUrZQsVkEK6xYfgXgppdqx2oNZUaky+gv8ZvdYtTb1LEWyTvOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YQiULbk6J/Wy4xlwmiRwGC77GEa/fYbAvwWoz25jV5I=;
	b=h/U2eWmgkSstYDbArDbTUmpcQtBYSvK8O0RzVVFekspbj7uk96S+GDu7sdIS4PiQtebo
	 WL6MUk2DDUotIXRhGSqosieKjjtIREkywZVbWbPGa0LF6awlh/P+azmYFl/FZolnAOmbY
	 d+tbCKJ27HoV3tWKuI90FzPPhuVxK4o5z661gmOU0PKdZuDUPhGGHMTFxBp//dgMpl/yi
	 JFBb7odQXS2fe87KPxhirY38OX72U1bhnteg3gIXp+AUFtloBrJcf4eHWwjuEUULVARDF
	 fLR+XfD377ZuDVJMxNMr/VPoBXlngS+YHtvsEV/iu4ZJ/OC+dk9pm4QRB+OthYgW9og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IU4TQUSi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C306606D80B;
	Wed,  4 Nov 2026 22:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IU4TQUSi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B071F0093A;
	Wed,  4 Nov 2026 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831516;
	bh=YQiULbk6J/Wy4xlwmiRwGC77GEa/fYbAvwWoz25jV5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IU4TQUSioZHeaO+8+TUg+To1KkZ7niUd5rGS6RgHnrXrdOBaoK1Q8pxOSCKYnJSZs
	 6ZrPKk3nKWwIES6FXxgWg5h8PiZN5e0uqRBtuSOeIBARyYm0I3YLg9IcVfCfljxJyA
	 eButDc/CWfss68RSP7wVBajmtfFu3aNaEu2RatD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0750/1005] media: rc: Fix use after free in bpf progs
Date: Wed,  4 Nov 2026 16:08:03 -0500
Message-ID: <20261104211104.462556528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit f95a9f8472f97c30106513fc7494b7abad243949 upstream.

Since commit dccc0c3ddf8f ("media: rc: fix race between unregister and
urb/irq callbacks"), rcdev->raw is no longer set to NULL after device
unregister. raw->progs could point to stale data.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/bpf-lirc.c  |   18 +++++++++++++-----
 drivers/media/rc/rc-ir-raw.c |   11 +++--------
 2 files changed, 16 insertions(+), 13 deletions(-)

--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -148,12 +148,13 @@ static int lirc_bpf_attach(struct rc_dev
 	if (ret)
 		return ret;
 
-	raw = rcdev->raw;
-	if (!raw) {
+	if (!rcdev->registered) {
 		ret = -ENODEV;
 		goto unlock;
 	}
 
+	raw = rcdev->raw;
+
 	old_array = lirc_rcu_dereference(raw->progs);
 	if (old_array && bpf_prog_array_length(old_array) >= BPF_MAX_PROGS) {
 		ret = -E2BIG;
@@ -186,12 +187,13 @@ static int lirc_bpf_detach(struct rc_dev
 	if (ret)
 		return ret;
 
-	raw = rcdev->raw;
-	if (!raw) {
+	if (!rcdev->registered) {
 		ret = -ENODEV;
 		goto unlock;
 	}
 
+	raw = rcdev->raw;
+
 	old_array = lirc_rcu_dereference(raw->progs);
 	ret = bpf_prog_array_copy(old_array, prog, NULL, 0, &new_array);
 	/*
@@ -235,7 +237,8 @@ void lirc_bpf_free(struct rc_dev *rcdev)
 	struct bpf_prog_array_item *item;
 	struct bpf_prog_array *array;
 
-	array = lirc_rcu_dereference(rcdev->raw->progs);
+	array = rcu_replace_pointer(rcdev->raw->progs, NULL,
+				    lockdep_is_held(&ir_raw_handler_lock));
 	if (!array)
 		return;
 
@@ -316,6 +319,11 @@ int lirc_prog_query(const union bpf_attr
 	if (ret)
 		goto put;
 
+	if (!rcdev->registered) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
 	progs = lirc_rcu_dereference(rcdev->raw->progs);
 	cnt = progs ? bpf_prog_array_length(progs) : 0;
 
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -650,8 +650,11 @@ void ir_raw_event_free(struct rc_dev *de
 {
 	if (dev->raw) {
 		timer_delete_sync(&dev->raw->edge_handle);
+		mutex_lock(&ir_raw_handler_lock);
 		if (dev->raw->thread)
 			put_task_struct(dev->raw->thread);
+		lirc_bpf_free(dev);
+		mutex_unlock(&ir_raw_handler_lock);
 		kfree(dev->raw);
 		dev->raw = NULL;
 	}
@@ -661,9 +664,6 @@ void ir_raw_event_unregister(struct rc_d
 {
 	struct ir_raw_handler *handler;
 
-	if (!dev || !dev->raw)
-		return;
-
 	/*
 	 * After ir_raw_event_unregister() is called, an sync
 	 * call to ir_raw_event_handle() can still arrive. This function
@@ -683,11 +683,6 @@ void ir_raw_event_unregister(struct rc_d
 
 	lirc_bpf_free(dev);
 
-	/*
-	 * A user can be calling bpf(BPF_PROG_{QUERY|ATTACH|DETACH}), so
-	 * ensure that the raw member is null on unlock; this is how
-	 * "device gone" is checked.
-	 */
 	mutex_unlock(&ir_raw_handler_lock);
 }
 


