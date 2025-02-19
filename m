Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DB61DFE18;
	Wed, 19 Feb 2025 08:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955114; cv=none; b=fG/HGxunC4xBg38n8quXLDjeqKAfbT7rP/RJybk1QmPt/207pa9vK3SXEM2BL/+EQdS8KD0N3zbvwcpBpK4FSwNrLAJcyb7sAUfFgepebBtHzQ8MI0WAwI/ZQWAn38XfGf9myip2zQ1YEBQpHtkSovZTixs231BRemI1NW/breA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955114; c=relaxed/simple;
	bh=7EqswwIOoxgaKwQvO/AZ7yQPeRXyXDBCHOUv7fFW+bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLPod0+vH/Y9I1AmKdDf0+4v+Z9mD9koOCXaCexBtPIphKNtkmADtFlP5QxmIN3vHOY0nCxorLLYp4V0HYisyK+VF3spk9V1l+8InSRa3gIs3j9sbl6g7YCRZmQ082kcHBTy2UWJqDO+yYKyjcd1ElXnHExVLcW7YbKTNbH4y2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZNGHM2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZNGHM2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EE1C4CEE6;
	Wed, 19 Feb 2025 08:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955114;
	bh=7EqswwIOoxgaKwQvO/AZ7yQPeRXyXDBCHOUv7fFW+bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZNGHM2VO20RT8RxyuwLSvdXPTwJVhg/9K3q0DLLKQqcxN4v7k0wB239zKWcQZk2I
	 +w/Dv6AKAyRmONstws+W8RpNpXxwQu9/Ot4GH7F8O0B6xWSFrZ8hIJihgXurN273y/
	 H6USH3Tn2rbOI+aCY4gJp099um0ofQrU2h8GvzwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.12 137/230] kbuild: userprogs: fix bitsize and target detection on clang
Date: Wed, 19 Feb 2025 09:27:34 +0100
Message-ID: <20250219082607.044422929@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 1b71c2fb04e7a713abc6edde4a412416ff3158f2 upstream.

scripts/Makefile.clang was changed in the linked commit to move --target from
KBUILD_CFLAGS to KBUILD_CPPFLAGS, as that generally has a broader scope.
However that variable is not inspected by the userprogs logic,
breaking cross compilation on clang.

Use both variables to detect bitsize and target arguments for userprogs.

Fixes: feb843a469fb ("kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1057,8 +1057,8 @@ LDFLAGS_vmlinux += --orphan-handling=$(C
 endif
 
 # Align the bit size of userspace programs with the kernel
-KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
-KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
+KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
+KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # make the checker run with the right architecture
 CHECKFLAGS += --arch=$(ARCH)


