Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BB0146D4C;
	Thu, 11 Apr 2024 10:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831404; cv=none; b=k/FAoYxBuhwNNbSvyJ9QLQ/QSnIh8X1Gv0fBPWPXoVqv0fxpLTeP8izzKFSgpaTrMwhdrm9zK6K1ikWggrqVGOmtNJtPFjsy1ApZ7lPmrsxbIirChYcmS4QAChjra2+2+rWf7SyTCtS3erY0dbwmabFJvLjmFd0VWYvcrB9JlH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831404; c=relaxed/simple;
	bh=4QlAGs/w0ROjpNYR2FQ+yfvEvkQ1mbjnJgmwoSQAl2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzt6THN0xzBZaKzR7DrfAkamJkGE2mGwobR8LS/UXKxqUgTa02BdjMP3ieB12pLCtt2zNCVi1OZPlmaAwIcMIvlr96jgRDvf+Rovn7uAjNSyi0CZRa/iWN/o7vuxUR81zNWg4a7gtol37R7gBELck2JR33IqwGRxEnBW+edNrOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg8+Vfd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg8+Vfd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A271AC43399;
	Thu, 11 Apr 2024 10:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831404;
	bh=4QlAGs/w0ROjpNYR2FQ+yfvEvkQ1mbjnJgmwoSQAl2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dg8+Vfd37++MkwE9BTZYhX22MEvpNEzkwwZEK3znv67DXi2aTaugGkWg5qWxOfUUj
	 q6yaGcJiQQwMOeS2MHqDeYFZKBKqO1eumJtxpB1HcApBejWKke+hi5emqsCGAPaheh
	 p9HFWdPteo1OnrAp5+0Gk1irkknLWfpKUg/4UFyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.6 104/114] gcc-plugins/stackleak: Avoid .head.text section
Date: Thu, 11 Apr 2024 11:57:11 +0200
Message-ID: <20240411095420.032104196@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit e7d24c0aa8e678f41457d1304e2091cac6fd1a2e upstream.

The .head.text section carries the startup code that runs with the MMU
off or with a translation of memory that deviates from the ordinary one.
So avoid instrumentation with the stackleak plugin, which already avoids
.init.text and .noinstr.text entirely.

Fixes: 48204aba801f1b51 ("x86/sme: Move early SME kernel encryption handling into .head.text")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202403221630.2692c998-oliver.sang@intel.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20240328064256.2358634-2-ardb+git@google.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/stackleak_plugin.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -467,6 +467,8 @@ static bool stackleak_gate(void)
 			return false;
 		if (STRING_EQUAL(section, ".entry.text"))
 			return false;
+		if (STRING_EQUAL(section, ".head.text"))
+			return false;
 	}
 
 	return track_frame_size >= 0;


