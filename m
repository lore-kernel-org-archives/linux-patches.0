Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEF64DBD6D;
	Mon, 31 Aug 2026 13:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183564; cv=none; b=swNUMqUHTDdsAABkEfrAVRBCcidT8be3jQv6DFVU9hXZjq7n35y/75RyXZz5saKsKL0JohF8dXBHf2W+OVDzvetztIYVELw2yB09fgJ7PPwwegprXQVMUFR9XnlCzyTE73EtaONE0I5v6MELnkKsKvpBSgk9zoS64q1of8zDZ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183564; c=relaxed/simple;
	bh=Yb7B5QNwXdwka799eC8e1Zqu9etchaqBfp9Rwd8UU24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usxM1pU1pevSqlGeLAgQFaLBKBCT8e0KFtI9V4cMCHXy0pzfjGE6svk20eWgEVH2xgo6BK41fEOp0hqpfcBTZVdeCxOIDlB/IkmALjQu054p76IJoR400Z0Q8wTk2MFltLTlhdhYDmLgFtwtORfU3yMeuuHWEaLgWnfARvc7F3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skXERQLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skXERQLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907581F00A3E;
	Mon, 31 Aug 2026 13:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183563;
	bh=W2gvgA+dODC6cwfi07jzixadlqpXXr5v6deRgfNobaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skXERQLlyA0wwD08FUAPHZaBeLNVXV2tBwMgoZSL/H0xUwVayN062RdKAGewCHdjW
	 v+nD3ry5Ik1oHfkX8e05pa+ru9sOsL27iYhi98NOM617LY+Gv0pdGjOa8OaGe87P7t
	 EzvRgPhyIyUxwVWT7tFMrOqXxyruMd0SX1jy1GEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 7.2 06/71] accessibility: speakup: unregister tty ldisc on later init failures
Date: Mon, 31 Aug 2026 15:33:31 +0200
Message-ID: <20260831133359.345135618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


