Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D0C23E356;
	Tue, 12 May 2026 18:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609308; cv=none; b=eYa7vo5bCu5Mw0xIJgQyS07WvavC11o298zWH+ypFytupiUzmDTM+EjdO+veTSjE8ZeKnxncw3Tta24bltL5WprIDJ7oOBoCv1E/U5GHsdYbbJeqrVeH8k04vGWJXjbJbpzrIDI7bi11+hEgOV0YIZeaufMMhGknuBjvQx78D1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609308; c=relaxed/simple;
	bh=QxFjrbQ+/hXgH8ZJRefonVLfpS8PDn8IRYStgAAUtnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZMNIM+FEUFtAiNDlt44wNuL/2I+NzTU7mDmIHaA6F4GKGzaHipl9fgb/bMWEZVM0FCtWBI3vXqJvACtBljjZSGaGbR/7O1vGtgdRzIFKZu/Z5Ll+eb+Pjhhg0vdS7zG2v1Y1K+AbDRgicVwukCX4O7sLUM49hbh+VzHCeulge4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWBYNm8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWBYNm8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEBEC2BCB0;
	Tue, 12 May 2026 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609308;
	bh=QxFjrbQ+/hXgH8ZJRefonVLfpS8PDn8IRYStgAAUtnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWBYNm8aCI3KYoR0msGc6EsmuMzjkgEQODxAD5L/cVvQCb6kgPpHZN2AdVCxi/k4C
	 KpltqfE4fyV0sdwirmoeUKIQLvF2aQrLmLBVmaV0mEagYqgY8IQVxpTp56eNfH0ahX
	 5rCbtV8Zo7MlKUfN+psIm7n18QjUcShmKOEECNiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hillis <Ben.Hillis@microsoft.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Dexuan Cui <decui@microsoft.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 144/307] hv_sock: Report EOF instead of -EIO for FIN
Date: Tue, 12 May 2026 19:38:59 +0200
Message-ID: <20260512173943.168319726@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dexuan Cui <decui@microsoft.com>

commit f6315295899415f1ddcf39f7c9cb46d25e2c6c6a upstream.

Commit f0c5827d07cb unluckily causes a regression for the FIN packet,
and the final read syscall gets an error rather than 0.

Ideally, we would want to fix hvs_channel_readable_payload() so that it
could return 0 in the FIN scenario, but it's not good for the hv_sock
driver to use the VMBus ringbuffer's cached priv_read_index, which is
internal data in the VMBus driver.

Fix the regression in hv_sock by returning 0 rather than -EIO.

Fixes: f0c5827d07cb ("hv_sock: Return the readable bytes in hvs_stream_has_data()")
Cc: stable@vger.kernel.org
Reported-by: Ben Hillis <Ben.Hillis@microsoft.com>
Reported-by: Mitchell Levy <levymitchell0@gmail.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260416191433.840637-1-decui@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/hyperv_transport.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -694,7 +694,6 @@ out:
 static s64 hvs_stream_has_data(struct vsock_sock *vsk)
 {
 	struct hvsock *hvs = vsk->trans;
-	bool need_refill;
 	s64 ret;
 
 	if (hvs->recv_data_len > 0)
@@ -702,9 +701,22 @@ static s64 hvs_stream_has_data(struct vs
 
 	switch (hvs_channel_readable_payload(hvs->chan)) {
 	case 1:
-		need_refill = !hvs->recv_desc;
-		if (!need_refill)
-			return -EIO;
+		if (hvs->recv_desc) {
+			/* Here hvs->recv_data_len is 0, so hvs->recv_desc must
+			 * be NULL unless it points to the 0-byte-payload FIN
+			 * packet: see hvs_update_recv_data().
+			 *
+			 * Here all the payload has been dequeued, but
+			 * hvs_channel_readable_payload() still returns 1,
+			 * because the VMBus ringbuffer's read_index is not
+			 * updated for the FIN packet: hvs_stream_dequeue() ->
+			 * hv_pkt_iter_next() updates the cached priv_read_index
+			 * but has no opportunity to update the read_index in
+			 * hv_pkt_iter_close() as hvs_stream_has_data() returns
+			 * 0 for the FIN packet, so it won't get dequeued.
+			 */
+			return 0;
+		}
 
 		hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
 		if (!hvs->recv_desc)


