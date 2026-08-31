Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9833F549392;
	Mon, 31 Aug 2026 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183985; cv=none; b=sgsUti8XfvFXj66bxK46I55D11YkVVRcReHEptJEWjkrtAhGFr3CfpC7P8soS6kAcbKPWeQT2iyBBqZmzZQr95thsnovATpENG5KE4zRSLIu0XXsWeI9xhrUkVqlIWecwYcUKwnJGN//B5Qi3GoT3LN/eimc8I+UXSNdVQq9RNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183985; c=relaxed/simple;
	bh=xmLRWAdFWW8E8nQuzonkCA3AeQPQtAXKFL7Ngwmp5sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxRcBfZepReW4SYet6jIUO8uf/I7L8X6omyeWCm7GMwg82TxoWxFcAvfHX5l5QuKni1JiGzlS5jE3qaIWV/eBORHqTiiwkdkGteoczMkMklooLVcy/2qP+qYtWoRSnDCCed6Lj5V3lik9/rosiWn9KlNRqcs625U3teWDhbjmHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCKYWanu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCKYWanu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84C71F0155A;
	Mon, 31 Aug 2026 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183982;
	bh=EqSMH6QDrm3qU0WtJTobkWxzB1pBq3PAo6hzDhywu7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCKYWanu2MB0NIfNA3xQzRLedifSjxRWLj4hT8IAaowON4G9T6zRm7sSIk8azvo+x
	 KumhvEASjXf9rdZ/3sfm5cziejx4m5mTboNb53VuVT4wt+FpktnTrhChiziKCMYmVa
	 npG7wqjUcypDTG8ZdPo0cophANWTzvgVKRWTVSzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.18 31/83] accessibility: speakup: unregister tty ldisc on later init failures
Date: Mon, 31 Aug 2026 15:34:07 +0200
Message-ID: <20260831133401.006790687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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


