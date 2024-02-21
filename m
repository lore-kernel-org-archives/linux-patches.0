Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDC069E00;
	Wed, 21 Feb 2024 13:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521090; cv=none; b=VGOUnlVACr/6dZtnnE2FAPazLzepi5yNUQX7TKHtxGuLNUvgHpLbNOYMXHugobIYDHursu9mQENa6UmHnvxsTnwMF0ylIisWmQ//yzzJwAp1ueY0CDt961Cpqf4CbjfsRZkEcYFxD46slnACSH9SYxfzB+F9Nd0+Xmxk9/uiSpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521090; c=relaxed/simple;
	bh=wkdeTaCjMlxGrDJGkInp5NrGlao3clkU1/3RmYR1byA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBmf+sPq15E/gd9lxtu8kGumgn2/apc8P/Wa3BgSUfDXzRd/jVbzY8piH7vQmcTIy9uKdYq2pj0B+TKQ/ATDEj8Cy3+UbTiCBB/HeNn++UJ9nEVVCVq8eN+Vk0RiwOHasBRjOUC2S4a1vzXeKayMGJjuVXUTQVJZ3NTGseejR9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ho75R7Ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ho75R7Ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4F7C43390;
	Wed, 21 Feb 2024 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521089;
	bh=wkdeTaCjMlxGrDJGkInp5NrGlao3clkU1/3RmYR1byA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ho75R7Ib8RVkPcNgBm6YP3H4mn2Jw1BWsjGOs9pnUfNDPD138ZryONE82UeKaLRha
	 iHRcDyJYNa5G5mPd1LFI+Hxe7+BTSS710fSmK99+Q+DmtUPGSIwyZi/uBFTRDyFCnA
	 3WHocfqh75CDD7Ki8W4/7HX+eULMzjdZpGOxVCF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 4.19 022/202] driver code: print symbolic error code
Date: Wed, 21 Feb 2024 14:05:23 +0100
Message-ID: <20240221125932.489711379@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 693a8e936590f93451e6f5a3d748616f5a59c80b upstream.

dev_err_probe() prepends the message with an error code. Let's make it
more readable by translating the code to a more recognisable symbol.

Fixes: a787e5400a1c ("driver core: add device probe log helper")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/ea3f973e4708919573026fdce52c264db147626d.1598630856.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3366,9 +3366,9 @@ int dev_err_probe(const struct device *d
 	vaf.va = &args;
 
 	if (err != -EPROBE_DEFER)
-		dev_err(dev, "error %d: %pV", err, &vaf);
+		dev_err(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
 	else
-		dev_dbg(dev, "error %d: %pV", err, &vaf);
+		dev_dbg(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
 
 	va_end(args);
 


