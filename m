Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99AB436344;
	Tue, 21 Jul 2026 18:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659837; cv=none; b=myNfsmnThxA99RRrVNmwPKQqMEPXVreF5RRSBo6wrOkPyr2VL2dEPwvrm0IwoDX5DuMJtIpxDaLSW3Z4j6HrBfzo3ptG+ydXohyTfVMn6sdLk13punouRzdAdU2k+xuxK092DUHnB/IVEzWPEaJEABMXkNOyy4BhCIlrieNCrRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659837; c=relaxed/simple;
	bh=HSIirep8MazkuYsf8DSs+wRW4LCn46uF/EAwcWWlilY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCKV70CaTHiJMpH3FmlkAArQJltOGZpyMeOWSKdXOrfLMnS3KDWLGE3VELpDHk5A2tzNxEn1OLc89TdLjS8Uz4uC2wKSEpthZhX2Lz8aqAa/EoZnZ3HLhkSE4czAZ9UhXDITG1/NMHdrtIZ/FXlXoKXC0UKoAcABZCj5uvF874E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3TTnfTg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3TTnfTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5E11F000E9;
	Tue, 21 Jul 2026 18:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659833;
	bh=ms+8P2VxJmXDLDcDvK9yfes1iw9lwr5KkKm6IYN5xp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3TTnfTgQIBQU1SAV9TWS4OUFsV5yn7el49bKVN4lj5P9dL7JxLEvT4+Me51gZGTU
	 2p8kYjIJmIwDWlfX5oJB2KaNJyC0BrSD5jiXHKwDzKmaDkeYSC8hPTLaP/SQ8+60so
	 gC6Mb1SdO6aQ10HgPARL0RA5k4NtiDtEvNPZRgMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0734/2077] vfio: selftests: Ensure libvfio output dirs are always created
Date: Tue, 21 Jul 2026 17:06:47 +0200
Message-ID: <20260721152610.110068573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

[ Upstream commit 785562e31dbcd85ca583cf58c446e63aa8a5af08 ]

Add an explicit dependency between the output object files and the
output directories that need to be created to hold those files. This
ensures that the output directories are always created.

Creating the output directories at parse time (current behavior) doesn't
support the scenario where someone does "make clean all". The
directories will be created during parsing, deleted during "clean" and
then not available for the "all" target.

Use an order-only prerequisite for the output directories, rather than a
normal prerequisite, to avoid unnecessary recompilations.

Fixes: 19faf6fd969c ("vfio: selftests: Add a helper library for VFIO selftests")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/kvm/20260610010314.DB8861F00893@smtp.kernel.org/
Signed-off-by: David Matlack <dmatlack@google.com>
Link: https://lore.kernel.org/r/20260611213945.3714421-1-dmatlack@google.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vfio/lib/libvfio.mk | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
index 9f47bceed16f4c..f90235a1043fe8 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.mk
+++ b/tools/testing/selftests/vfio/lib/libvfio.mk
@@ -19,11 +19,13 @@ LIBVFIO_OUTPUT := $(OUTPUT)/libvfio
 LIBVFIO_O := $(patsubst %.c, $(LIBVFIO_OUTPUT)/%.o, $(LIBVFIO_C))
 
 LIBVFIO_O_DIRS := $(shell dirname $(LIBVFIO_O) | uniq)
-$(shell mkdir -p $(LIBVFIO_O_DIRS))
+
+$(LIBVFIO_O_DIRS):
+	mkdir -p $@
 
 CFLAGS += -I$(LIBVFIO_SRCDIR)/include
 
-$(LIBVFIO_O): $(LIBVFIO_OUTPUT)/%.o : $(LIBVFIO_SRCDIR)/%.c
+$(LIBVFIO_O): $(LIBVFIO_OUTPUT)/%.o : $(LIBVFIO_SRCDIR)/%.c | $(LIBVFIO_O_DIRS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 EXTRA_CLEAN += $(LIBVFIO_OUTPUT)
-- 
2.53.0



