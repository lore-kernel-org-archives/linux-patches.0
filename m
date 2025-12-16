Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30D634573C;
	Tue, 16 Dec 2025 12:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886444; cv=none; b=um7bdMN4d/RfVuGrV3yCUn+CjxtK5bHHnExlYOfWWUQpUxCylMhhjKE5CxBJq+LDKET/C3iNJBExhF26Qxf695elFrdKCYfGBgjJ8DCgQwSk9Tya/gNFJq8m6iSa5eYJWKJv31a6XEld0d96fmfYekmsHuEpf/+/dg5VQvZiL7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886444; c=relaxed/simple;
	bh=cA6rF+Nbqcro8MVyhjkktINb/eeplvIkingLnggH2/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgFWqKXDjKlt2tKv0Qp9b94rzcDUWy/bE+n57bLFm6u0fKcyD4ljcwE5lH9oUT7V6W3C0UlAkGF0lU5miCVlDo0VCnwcZz5Gwf1VkzXzRtfyFcpHLa/Hipt6FTQ73dJe8P7VACar7+bE3EtBNN536NH5louUYdW9+Uxvzi82gbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0puYEQZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0puYEQZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CD8C4CEF1;
	Tue, 16 Dec 2025 12:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886444;
	bh=cA6rF+Nbqcro8MVyhjkktINb/eeplvIkingLnggH2/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0puYEQZx/rNm42GFHvGggRZLWqMPI7/7qix0yO6Vz/XESLGS66fHzm0sNfo2yoSk/
	 +nqRjPshu8e8c2WG7JcCO8+vNksuJeudF/W5f8WatsrCjyr8cWOKHhuGnERL7Edoha
	 IElPaw6w2tGkOjI8g0zwWr9mA2LjeJX/E5SgbYQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 439/507] kbuild: install-extmod-build: Properly fix CC expansion when ccache is used
Date: Tue, 16 Dec 2025 12:14:40 +0100
Message-ID: <20251216111401.361829783@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 4ab2ee307983548b29ddaab0ecaef82d526cf4c9 ]

Currently, when cross-compiling and ccache is used, the expanding of CC
turns out to be without any quotes, leading to the following error:

make[4]: *** No rule to make target 'aarch64-linux-gnu-gcc'.  Stop.
make[3]: *** [Makefile:2164: run-command] Error 2

And it makes sense, because after expansion it ends up like this:

make run-command KBUILD_RUN_COMMAND=+$(MAKE) \
HOSTCC=ccache aarch64-linux-gnu-gcc VPATH= srcroot=. $(build)= ...

So add another set of double quotes to surround whatever CC expands to
to make sure the aarch64-linux-gnu-gcc isn't expanded to something that
looks like an entirely separate target.

Fixes: 140332b6ed72 ("kbuild: fix linux-headers package build when $(CC) cannot link userspace")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20251111-kbuild-install-extmod-build-fix-cc-expand-third-try-v2-1-15ba1b37e71a@linaro.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/install-extmod-build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/install-extmod-build b/scripts/package/install-extmod-build
index 054fdf45cc37a..2576cf7902dbb 100755
--- a/scripts/package/install-extmod-build
+++ b/scripts/package/install-extmod-build
@@ -63,7 +63,7 @@ if [ "${CC}" != "${HOSTCC}" ]; then
 	# Clear VPATH and srcroot because the source files reside in the output
 	# directory.
 	# shellcheck disable=SC2016 # $(MAKE) and $(build) will be expanded by Make
-	"${MAKE}" run-command KBUILD_RUN_COMMAND='+$(MAKE) HOSTCC='"${CC}"' VPATH= srcroot=. $(build)='"$(realpath --relative-to=. "${destdir}")"/scripts
+	"${MAKE}" run-command KBUILD_RUN_COMMAND='+$(MAKE) HOSTCC="'"${CC}"'" VPATH= srcroot=. $(build)='"$(realpath --relative-to=. "${destdir}")"/scripts
 
 	rm -f "${destdir}/scripts/Kbuild"
 fi
-- 
2.51.0



