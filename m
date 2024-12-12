Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5EC21171A;
	Thu, 12 Dec 2024 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016380; cv=none; b=HrdbPA2/w18hSw+yN43uZAqjPf8rlwwb58SzC9P07oBGB74V57k6BjuonF4GoBVjamrGzTk5HAvUP10YQ9YgyJPolhj1SJ4XXxrOM5Xwb2AQrR7JZzQKDBfBaoOcTCC5hAmNpwBXF3XXCK4VXq0QeeA6+OO+aNxtnqPoQxfycBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016380; c=relaxed/simple;
	bh=5Xke635Nf6Ho7go3PB0ST9u9+3EmC8uipVEPAjj2sL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiZjocTPrgj5W0oyMunX0/2A3LGZyLL1hTRq7wdau7KoU1t6Aby8/Fu5Ogpn1loCIzJbFysFodZZEmkpE28lZjIz8SQKYjiApGGgncO0COxSjBr1UkfL/DXGZTXmdwWm2xBFuN+l7uXHjIuXpmQ1RJ6wpEirsOt9tTYfyDVzPFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9nXPBvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9nXPBvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271B7C4CED0;
	Thu, 12 Dec 2024 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016379;
	bh=5Xke635Nf6Ho7go3PB0ST9u9+3EmC8uipVEPAjj2sL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9nXPBvrefWfr82IZta8Udpb8bKikj6FkwubBA7a7e9eQRBWAHEXlLzouKsaivvBb
	 MnHKSLuIGzrb6Mikpj43DuJ9sX1B+LdseodNFQVl9S8ThTXCOUYN1PHFK8OU5Qoqed
	 aL7KFc946iGPH0QRaxhbwrdLkSebhEcZ1Db+7Wp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.12 182/466] modpost: Add .irqentry.text to OTHER_SECTIONS
Date: Thu, 12 Dec 2024 15:55:51 +0100
Message-ID: <20241212144313.987115997@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 7912405643a14b527cd4a4f33c1d4392da900888 upstream.

The compiler can fully inline the actual handler function of an interrupt
entry into the .irqentry.text entry point. If such a function contains an
access which has an exception table entry, modpost complains about a
section mismatch:

  WARNING: vmlinux.o(__ex_table+0x447c): Section mismatch in reference ...

  The relocation at __ex_table+0x447c references section ".irqentry.text"
  which is not in the list of authorized sections.

Add .irqentry.text to OTHER_SECTIONS to cure the issue.

Reported-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org # needed for linux-5.4-y
Link: https://lore.kernel.org/all/20241128111844.GE10431@google.com/
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -785,7 +785,7 @@ static void check_section(const char *mo
 		".ltext", ".ltext.*"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", \
-		".coldtext", ".softirqentry.text"
+		".coldtext", ".softirqentry.text", ".irqentry.text"
 
 #define ALL_TEXT_SECTIONS  ".init.text", ".exit.text", \
 		TEXT_SECTIONS, OTHER_TEXT_SECTIONS


