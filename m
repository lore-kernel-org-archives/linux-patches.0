Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623614;
	b=WXF2N8PA1H3gPyP1tn9vGFNiNd+H9xVTCXWTPt74Ah017leTkrNJt8UcW3DuCQ475D4h
	 9t7l9Srm8/U6etJIjYtodB9RvLahLz3jGzTzmlMozv4M2OPTuJJWZ+vCR+YrsreV79O7g
	 gXzHCxa/DxGLXnvcOLaRG3S5QSyxtHx73l2h1MO8Aixpd+nFBPkmKt10R+2FaoVLvOwJx
	 n8fpSYeQswnBNq/Q3H4K0c8MXc/Iu3/hD5ofuPwvXZxV/tC/wzi7oRW5AqbLl9dgZiK4M
	 LFR/BYgGvfGdl00bzj4y/R5IOcVJ1XRpiHAiiXu4HdIYoIiWBQDddNQKIO6auRR64Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oNQLAazkzWlseegfCXYN3s5PWWWXzA2L9dmPQI4m8jM=;
	b=UODWhUqViuAg8E+b+j61JK97wgH5s9elfgjYQsiU/tnlKd8nL9a0N+lU1enplHDxYb9E
	 cpl2B/vZHEaSzsl7KE+BnTdo2xPjAha6N+kBV/SL0Y03uuyJO1Rxpmn02rMdsiN+k5jl4
	 7Ccuwt37S4n53Bu1hGNTr2Wp0MVVVS0G85o2TplF6YXjn7nOri4h01zVVqPDxa5GnrJGx
	 LxfkwdLJrYJwW1ZiMkyBRaGgFK2QQWzW4SaHlE2YXL4z8/x0oUWuxFlZQS4kcMzH0A2Ra
	 sstG7oXD56WRVyk00Iiyc7E7vRi2JpJHx6nkJqdK2fHS9x3AiHNIZnVPR76k3JWPw0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/Nad7rk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D687606A321;
	Wed, 25 Nov 2026 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/Nad7rk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CE81F000D8;
	Wed, 25 Nov 2026 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623613;
	bh=oNQLAazkzWlseegfCXYN3s5PWWWXzA2L9dmPQI4m8jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/Nad7rkG3CTXPj0AIW+fezOxmwPfRTFHH0EEUQ3uS82Hpjo73hp9ywfnYa/2UOum
	 zvvYFADWX/Vphd8sOZAyK6n8cXvrX0qZPegTqXnLNiyTOENqNHRe7gpsRgmBFnJbJ4
	 souiot1zKM161Z7SIHwDttVqPD8WGwQY+oAzfLkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.18 915/990] usb: dwc3: gadget: Clear delayed stop on End Transfer completion
Date: Wed, 25 Nov 2026 15:38:02 +0100
Message-ID: <20261125143843.437710078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit f2bd20f92a7dc68980a6098397503067192ce63a upstream.

When an End Transfer command times out outside of the SETUP phase, the
driver sets DWC3_EP_DELAY_STOP to retry it on the next SETUP phase. If
the command completes in the meantime, the flag is left set. Requests
queued to the endpoint are then deferred, and the retry may end a
transfer that is started later.

Clear DWC3_EP_DELAY_STOP when the End Transfer command completes.

Fixes: 4db0fbb60136 ("usb: dwc3: gadget: Don't delay End Transfer on delayed_status")
Cc: stable <stable@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/c28a9660f7b6bfa626077ddcfbadd50e6b503f86.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3861,6 +3861,7 @@ static void dwc3_gadget_endpoint_command
 	if (dep->stream_capable)
 		dep->flags |= DWC3_EP_IGNORE_NEXT_NOSTREAM;
 
+	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
 	dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	dwc3_gadget_ep_cleanup_cancelled_requests(dep);


