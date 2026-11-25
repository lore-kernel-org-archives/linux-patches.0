Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623632;
	b=BKlxNxpJR73gpVJ9xbIl6tHM6cdrIweWjUv0+TW7kVWtt9W+4PZyS++YDtnAE/aZGKrd
	 UKTnoTX6+gkNeTUNi/YqCj8TCq/5J9jRgzRrlT57RgrxaLvM4oFR/mAcbEnMK3wJWPy/s
	 ngLm0Y/1vN2SNR7XGFBQB4t09syWmXciX0peB8dbdMOvpGLEXbilPv48UkXGPgwo0EO5i
	 h9huOUVsJmL21skNhWsxlwrb6VktHBAeLYkatkbRNydvHzQWzlNfLbdHT4ov7VzbBPgdP
	 n8P0DImXw58TBSBetYcBr5+4vvvv4cOXacuAjFTO4pCZ2CIbrz8VCL9W7fo5rAQODpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1zhrRXs6ledTyerWNGgVVP0UKOFSqLWos0Qq83Onodo=;
	b=ZI1xsyjxFhG5AOvURg8ikXNRdRU+uEYyH0q8ZgR1RYLDo9AGs416gBBbKwi7PUE5XUVq
	 fXifScxydQfI5hPm0TIFtnPSSv9+WGT0Qb+0ik7d7zWjcRaVL/cdKT4bG4hNDw4aLvmc9
	 t2StzfcoMb/zvI3Vysp8iE5oZcKNrBolNfMJXm8w/7HMwjdTI8nFW39yNNHQ7wCplqXmT
	 W4RpriuG62M8J3roCCs0S2qH/tPJOgoKsU2bxUwM0hV36KFSBRptnvIFu9eJEy8yX9ieT
	 IBJem/xz5X0kxuWU0re/75TjdfEjHOGonWO0q5UFetxvyOPQp/ARKPOfhvugopspYnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLny114k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C673F606A337;
	Wed, 25 Nov 2026 16:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLny114k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DB61F000C4;
	Wed, 25 Nov 2026 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623632;
	bh=1zhrRXs6ledTyerWNGgVVP0UKOFSqLWos0Qq83Onodo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLny114k44VGxvpsr6f7bYaL9XVhbaUUmn95b+By8VgIu5UUuz0IovvvdnZkYgLuD
	 jvL2cSHO7zNf/oVTidXsb+z/RBErdELiNn/Wx+n5Kr8lkI3c1//UApllwrhAGph7w+
	 JhTsTTPj+Em0OyEbtat9GaTraQ3PVdlxYuMZOt4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.18 920/990] usb: dwc3: gadget: Track a timed out End Transfer
Date: Wed, 25 Nov 2026 15:38:07 +0100
Message-ID: <20261125143843.551678688@linuxfoundation.org>
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

commit af91c6322e633504aa45de278f5d520f39d127be upstream.

If an End Transfer command with CMDIOC times out, the driver clears the
resource index but keeps DWC3_EP_TRANSFER_STARTED without setting
DWC3_EP_END_TRANSFER_PENDING. The command is still outstanding, but a
later stop issues another End Transfer with resource index 0, and the
next Start Transfer fails with "No Resource".

Mark the timed out End Transfer as pending so that no other command is
issued to the endpoint until it completes. For any other failure, there
is no outstanding command, so clear DWC3_EP_TRANSFER_STARTED.

Fixes: e192cc7b5239 ("usb: dwc3: gadget: move cmd_endtransfer to extra function")
Cc: stable <stable@kernel.org>
Reported-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Closes: https://lore.kernel.org/linux-usb/3fdda532-8181-48e9-b58d-cad7289408e7@samsung.com/
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/5815c41a7e7923edb114741f29697cf0161f523c.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1806,9 +1806,9 @@ static int __dwc3_stop_active_transfer(s
 
 	dep->resource_index = 0;
 
-	if (!interrupt)
+	if (!interrupt || (ret && ret != -ETIMEDOUT))
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	else if (!ret)
+	else
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
 
 	dep->flags &= ~DWC3_EP_DELAY_STOP;


