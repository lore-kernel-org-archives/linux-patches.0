Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061522;
	b=VVObM5TdRDksQF8zag8HYqvoiIQGuZFPnFjTYQaQ968wl0UUGDyu9K8SGwW66+7kBVBh
	 2eYruHoLJlZHNefB8M0l0noqdSMT2TsDDyU88zua5DNeD0BAJ1Yz/pJI7/yRCGRXFQERl
	 z/yPuJt4dcEQaARCVVg5Yi2veL47h2hRNQ3UZEoLcduGPk0lF05ZR3lTMTYT0yCdYA5vt
	 zFYPX4PPQHSP6JR7xx8M8JmKfbpV2/xpkm/dWeH5g5jaGWBGFQ5rGdyxWopCvRVJzwpuK
	 a4tHGWYAz2ph4tNYvvkVRX/FhYQfoQEWMnTeAFDquExpfz/kNIvE+nAm1Cp6AmydE6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GoCNV9XS2pCR2LgIckltk5GimfDHUjEWeDvVXwZL4Cs=;
	b=qZX4oECum5SonpDJ4v3QReIxwsdheEqkoBjWYGy2G+FQggwxOsidu6OODV9bE83dGepP
	 ape5EosUxE7OxxdiCN0uCe0lg0cKvEWnY8K/brA8jMpbrw+PnH4TH9DHHly+Ff4VYTmr1
	 EC5N0YyEST9KNCqOBzExL9C39QYoUyC2ZTQ8N8FeKPmiMwoVyTqAVNoiDTAovImQsvktw
	 yDVBP675QJKKCy4M+PiD+In65aCPNdjEyM6Uevdtwr2ruXClhz7AKHjoZCnyeTRpcqfks
	 c41EjBOfekg0s6v17gEtMmT02yEthmjUi1YCxYX7YVQx3XWszqZ2ZR2fQzP8r3FLx2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uaI6G0lE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932E2606A32E;
	Sat,  7 Nov 2026 14:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uaI6G0lE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4060A1F0089F;
	Sat,  7 Nov 2026 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061522;
	bh=GoCNV9XS2pCR2LgIckltk5GimfDHUjEWeDvVXwZL4Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uaI6G0lEbqf4lkxpfcuAbD2kZihdbwQqhLmano0OxtUT1kz/Bwr8A882V+Uk51/Bi
	 YHs+yev/ogh7W0vP/8rHYwyPdJMDqGo40Q+pmWzmDqMIiIECmtTX2IhSzX+nsvkZlN
	 dI1DEl/U13ykYfMYAm6Iijm2y0VUvZGA37e1fKaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0610/1536] media: au0828: fix use-after-free in bulk_timeout timer on disconnect
Date: Sat,  7 Nov 2026 08:43:46 -0500
Message-ID: <20261107135014.671817171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 521030837bee352515d5ea57cc6a29581db3506e upstream.

start_urb_transfer() arms dev->bulk_timeout, whose callback
au0828_bulk_timeout() queues dev->restart_streaming; that work in turn
calls start_urb_transfer() and re-arms the timer.

au0828_dvb_unregister() cancels restart_streaming on disconnect but does
not sync bulk_timeout. au0828_usb_release() then frees dev with kfree(),
so a timer still armed or pending at that point can fire after the free
and dereference dev through timer_container_of().

Sync the timer with timer_shutdown_sync() before cancel_work_sync().  The
timer callback queues the work, so the timer must be stopped first; the
shutdown variant is needed because the work re-arms the timer through
start_urb_transfer().  The dvb->frontend == NULL early return guards the
register-failure path where the timer was never set up.

This bug was found by static analysis.

Fixes: 53460c53b761 ("[media] au0828: Add timer to restart TS stream if no data arrives on bulk endpoint")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/au0828/au0828-dvb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -537,6 +537,7 @@ void au0828_dvb_unregister(struct au0828
 	if (dvb->frontend == NULL)
 		return;
 
+	timer_shutdown_sync(&dev->bulk_timeout);
 	cancel_work_sync(&dev->restart_streaming);
 
 	dvb_net_release(&dvb->net);


