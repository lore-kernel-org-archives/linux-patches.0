Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAFE1E98F6;
	Wed, 15 Jan 2025 10:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938394; cv=none; b=b+ir/TnZlrrRi4TLlOLgSaPoSaHnzqsNsqnJxG2FfTkZC1xCQbGV4bU/VmHPrCiS37HjnG5AMUwro6WhZWHXv23EXqIYbtzHCE7Txa4trIbe2RKUP8ZybxHi2QuyYivKF0pXHG+IgxHZVwJ758jq1wlpVwZEhQ5qvNq2k44wBYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938394; c=relaxed/simple;
	bh=Xmjf8xMInVLrR8cLHd1bpZ1e/2dc6Vsaq57oDXSMVrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLT4ZfzY3jpSHZTHVoVJLHPNyapD9LwlsFQA9BGeaKIT4R5L5io6VHv54IzCQXhLGrF/G02ptGFfOOz+fFsfQEr2FSYr+0WIPjCmoaZRgIlEdkaiDE+LNbx6sZC1sDyWdCQzRxv9fRScGfaLrgpn8rynESF0p7M4sSgKkJjkJMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiGffQj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiGffQj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B256C4CEDF;
	Wed, 15 Jan 2025 10:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938394;
	bh=Xmjf8xMInVLrR8cLHd1bpZ1e/2dc6Vsaq57oDXSMVrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiGffQj+iGnwEx9zHQ8zPpapX8eEl0IdfePbg0+9Uyr4PO9R026qS4pcZRFVQ+a5n
	 WxWKDTEakhQCw+gFXOokotk/kADPBIrOIKfkeqoD3vfyF0ba21bmPxF0j8i5wb0YMv
	 oE++G1eSs1/8KwCEx89EeziKwch6EZKoy8QKm1iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 170/189] iio: adc: at91: call input_free_device() on allocated iio_dev
Date: Wed, 15 Jan 2025 11:37:46 +0100
Message-ID: <20250115103613.191890645@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit de6a73bad1743e9e81ea5a24c178c67429ff510b upstream.

Current implementation of at91_ts_register() calls input_free_deivce()
on st->ts_input, however, the err label can be reached before the
allocated iio_dev is stored to st->ts_input. Thus call
input_free_device() on input instead of st->ts_input.

Fixes: 84882b060301 ("iio: adc: at91_adc: Add support for touchscreens without TSMR")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241207043045.1255409-1-joe@pf.is.s.u-tokyo.ac.jp
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -979,7 +979,7 @@ static int at91_ts_register(struct iio_d
 	return ret;
 
 err:
-	input_free_device(st->ts_input);
+	input_free_device(input);
 	return ret;
 }
 


