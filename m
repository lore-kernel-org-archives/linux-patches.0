Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8EE439F7E;
	Mon, 31 Aug 2026 13:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184588; cv=none; b=uRw8li6R0dHgZ00+tvwSq8nG+aw2Ep9mb8DtZNA5garrebuO49drn5X+Yqy6HD2c7RKIFrzMsYmQyq7vWNQi7NlHQPVPIcCtbrTA1K6G74TOgEIqVl7MHsTih5eeu0tr8oIIeAaDZoLd9JOgdvleqbQRDWPDHauXkTdrj2MIi/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184588; c=relaxed/simple;
	bh=Kc+WmxYB5rjjmH+QKjYLsZ1AlCE/wjS2gU2RWFm77io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qq9CL4nrB8laVL8qdlgO/1WMfbRhaa8m1M6l/vYMvQkVzW1hrhEivW+5FBnuKUq6CCa8UXI+NdeDbH4EZ9ZKk873dWMr583BsgaL6Ti+/Q7YoTG1zO3QvNylpMeydI/MUbwTuNavhI8hNhaTViYGQ9gckhEwFWnM5CzKcr3lP0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS+D9l5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS+D9l5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F9B1F000E9;
	Mon, 31 Aug 2026 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184586;
	bh=a3Ya3REeG+HkreWKEXynGMNPjT0ebu5eJXx9KI/hNo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SS+D9l5CsWGbpqusGYdtd7EslZry4nV0rjfzSw6IBU2Nq4eVKpfCgygd3OtedQS2N
	 PUAREsuW7lnkl6fOmtyQw4d/iAErzmdWSDPNhGJXa2o5lDDCd/HUrRhsSzIc0aA2x/
	 PVCEJEWGdh7fluNxmfEBSTA9+6ArYyJOWZSmUZCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.6 58/91] accessibility: speakup: unregister tty ldisc on later init failures
Date: Mon, 31 Aug 2026 15:34:46 +0200
Message-ID: <20260831133402.755249394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit a76acbaec9b8fd74413646984d2e3626d0543e39 upstream.

The ldisc registration is intentionally non-fatal, since some synth
drivers do not use tty/ldisc.  However, once speakup_init() continues
past the registration point and later fails, the init unwind path should
mirror speakup_exit() and call spk_ttyio_unregister_ldisc().

Add the missing unregister call to the error path after synth_release(),
matching the normal module exit cleanup order.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: e23a9b439ce9 ("staging: speakup: safely register and unregister ldisc")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260531230804.254962-16-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -2444,6 +2444,7 @@ error_kbdnotifier:
 	mutex_lock(&spk_mutex);
 	synth_release();
 	mutex_unlock(&spk_mutex);
+	spk_ttyio_unregister_ldisc();
 	speakup_kobj_exit();
 
 error_kobjects:


