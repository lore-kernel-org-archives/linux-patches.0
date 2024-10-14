Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADD01AE01B;
	Mon, 14 Oct 2024 14:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917282; cv=none; b=pbZ+E4H5cNzoGk+uxo8oji8AKuf0p1q5k2rwFjPqnuf8PqKzksRUVzDN+G4mXbywpslQMLMA0FAtYMzEbOKeoMSlloAYRsJnig5gIPM8xmFNamtEkudt7uWmJA2Q4lHdqKmz7hG3at/iJGrHxSiXu7vfDWEm0CdyWuZtQKLRxuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917282; c=relaxed/simple;
	bh=FTxJAUJQ/xUcWWo9wrd2mhhBoPqtEhgNaVHqp/IJebg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLe6PGkQzuENab8rwcJXprZCk7cwShWw3j+xn9KJoiqBx6T5sD6dtbR838u13ov54mQPgNQxh6WaZS5ZD2T5q1ZQOhd69hLZhIXgfDOdhtF+q7VAXXQutEG9KbKQOaA7+lF6iKFX9XSYPDCeow3gaAEj8E+XRRjCNeOCrjWy8JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qAz+4o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qAz+4o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CF9C4CEC3;
	Mon, 14 Oct 2024 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917282;
	bh=FTxJAUJQ/xUcWWo9wrd2mhhBoPqtEhgNaVHqp/IJebg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qAz+4o2Qcrtw//xQJ1l1t0x6F7Z6o9i2oi0jLmcNkcneIInXV9cgDZVEGqa7xhzN
	 v6tQECMeR436m6fCw0CrA7O7x7u2cQ15mzTkZTswNUMMDRdkp10zZUMV7wqHEHmdtp
	 /+nEkYJ4tnMHna4uw9ini4qEBOCYHNs44E300+XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 204/213] powercap: intel_rapl_tpmi: Fix bogus register reading
Date: Mon, 14 Oct 2024 16:21:50 +0200
Message-ID: <20241014141050.923580856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zhang Rui <rui.zhang@intel.com>

commit 91e8f835a7eda4ba2c0c4002a3108a0e3b22d34e upstream.

The TPMI_RAPL_REG_DOMAIN_INFO value needs to be multiplied by 8 to get
the register offset.

Cc: All applicable <stable@vger.kernel.org>
Fixes: 903eb9fb85e3 ("powercap: intel_rapl_tpmi: Fix System Domain probing")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Link: https://patch.msgid.link/20240930081801.28502-2-rui.zhang@intel.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_tpmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -192,7 +192,7 @@ static int parse_one_domain(struct tpmi_
 			pr_warn(FW_BUG "System domain must support Domain Info register\n");
 			return -ENODEV;
 		}
-		tpmi_domain_info = readq(trp->base + offset + TPMI_RAPL_REG_DOMAIN_INFO);
+		tpmi_domain_info = readq(trp->base + offset + TPMI_RAPL_REG_DOMAIN_INFO * 8);
 		if (!(tpmi_domain_info & TPMI_RAPL_DOMAIN_ROOT))
 			return 0;
 		domain_type = RAPL_DOMAIN_PLATFORM;


