Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5483326988C;
	Tue,  8 Apr 2025 12:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117013; cv=none; b=RWqoYS+4CSWK8rlRY+S8WB3qElKXbsEjETP+1/1db2jGTFg+yWp1BQcyWAmZnyVMz58fOKj8FmyvzabedMOFbx94K5QP0EhPI49uyGx9/tVisPOKmj1bEFHufFJutINEpMO3w29R+DvK6rGfelWOG7Px3iA113aNNWDu4ysvRQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117013; c=relaxed/simple;
	bh=kkkBArFyb9SqS37KeyaL9JmGYFbA0vXoP4U7E/tO66g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3QAwpLqUXykmpHyi84qJ2YcmCvZqXenv5yx1SRfuCE+KT9UaqBNShyFDb2+YaS4ho3zsi08/oEOsRWaG1BaC2970kp1umQ7HR3kph/U/Rr4djZ+1cAgwbR2XJf/q+VGxsvNr3onlAO+BVbXUeLddK9mmqR7Ly6RJGZHIWwzvuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhs1qemE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhs1qemE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C5FC4CEE5;
	Tue,  8 Apr 2025 12:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117012;
	bh=kkkBArFyb9SqS37KeyaL9JmGYFbA0vXoP4U7E/tO66g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhs1qemExCeqXXl37wcK0zLSfBbKTwKAt5nkx+WEcDiZ2z75LjM5eQ2ldDAbfJ2o7
	 pVoZp1dm5Co9HIAMJuo5yUTdhn8TktgllyWZvUBhIDQgvLgSu8Git3RyJCePlPhscW
	 KYzx93PYkE1fWL7PVPQLFv9sNOX0R+Db0lu6xOjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 345/423] kbuild: deb-pkg: dont set KBUILD_BUILD_VERSION unconditionally
Date: Tue,  8 Apr 2025 12:51:11 +0200
Message-ID: <20250408104853.875995761@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexandru Gagniuc <alexandru.gagniuc@hp.com>

[ Upstream commit 62604063621fb075c7966286bdddcb057d883fa8 ]

In ThinPro, we use the convention <upstream_ver>+hp<patchlevel> for
the kernel package. This does not have a dash in the name or version.
This is built by editing ".version" before a build, and setting
EXTRAVERSION="+hp" and KDEB_PKGVERSION make variables:

    echo 68 > .version
    make -j<n> EXTRAVERSION="+hp" bindeb-pkg KDEB_PKGVERSION=6.12.2+hp69

    .deb name: linux-image-6.12.2+hp_6.12.2+hp69_amd64.deb

Since commit 7d4f07d5cb71 ("kbuild: deb-pkg: squash
scripts/package/deb-build-option to debian/rules"), this no longer
works. The deb build logic changed, even though, the commit message
implies that the logic should be unmodified.

Before, KBUILD_BUILD_VERSION was not set if the KDEB_PKGVERSION did
not contain a dash. After the change KBUILD_BUILD_VERSION is always
set to KDEB_PKGVERSION. Since this determines UTS_VERSION, the uname
output to look off:

    (now)      uname -a: version 6.12.2+hp ... #6.12.2+hp69
    (expected) uname -a: version 6.12.2+hp ... #69

Update the debian/rules logic to restore the original behavior.

Fixes: 7d4f07d5cb71 ("kbuild: deb-pkg: squash scripts/package/deb-build-option to debian/rules")
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/debian/rules | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/package/debian/rules b/scripts/package/debian/rules
index ca07243bd5cdf..2b3f9a0bd6c40 100755
--- a/scripts/package/debian/rules
+++ b/scripts/package/debian/rules
@@ -21,9 +21,11 @@ ifeq ($(origin KBUILD_VERBOSE),undefined)
     endif
 endif
 
-revision = $(lastword $(subst -, ,$(shell dpkg-parsechangelog -S Version)))
+revision = $(shell dpkg-parsechangelog -S Version | sed -n 's/.*-//p')
 CROSS_COMPILE ?= $(filter-out $(DEB_BUILD_GNU_TYPE)-, $(DEB_HOST_GNU_TYPE)-)
-make-opts = ARCH=$(ARCH) KERNELRELEASE=$(KERNELRELEASE) KBUILD_BUILD_VERSION=$(revision) $(addprefix CROSS_COMPILE=,$(CROSS_COMPILE))
+make-opts = ARCH=$(ARCH) KERNELRELEASE=$(KERNELRELEASE) \
+    $(addprefix KBUILD_BUILD_VERSION=,$(revision)) \
+    $(addprefix CROSS_COMPILE=,$(CROSS_COMPILE))
 
 binary-targets := $(addprefix binary-, image image-dbg headers libc-dev)
 
-- 
2.39.5



