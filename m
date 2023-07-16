Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B28F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDFBC433C7;
	Sun, 16 Jul 2023 20:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538683;
	bh=RuxCvLCAdy8uCvcht9LUd3LUIlYGJU8po1vtEW3xriU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZ9ApIcFA6nnJL/Y+PyWwx5JDK6/VrMbfyzeMnnLvkBA/XAQcvH8fEbMGKw2il8vI
	 4afueu4CXeh33yF7wrdUaWmi9HzAfGQ0lpzaIMkvKlAlOUzEYbaWNmIGXwTLjYbM9C
	 uAP5Nr95zBoirO7BuAoD8bE0ddDo3IJvsfBYOc3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 539/800] kbuild: deb-pkg: remove the CONFIG_MODULES check in buildeb
Date: Sun, 16 Jul 2023 21:46:32 +0200
Message-ID: <20230716195001.612537127@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 1240dabe8d58b4eff09e7edf1560da0360f997aa ]

When CONFIG_MODULES is disabled for ARCH=um, 'make (bin)deb-pkg' fails
with an error like follows:

  cp: cannot create regular file 'debian/linux-image/usr/lib/uml/modules/6.4.0-rc2+/System.map': No such file or directory

Remove the CONFIG_MODULES check completely so ${pdir}/usr/lib/uml/modules
will always be created and modules.builtin.(modinfo) will be installed
under it for ARCH=um.

Fixes: b611daae5efc ("kbuild: deb-pkg: split image and debug objects staging out into functions")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/builddeb | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index f500e39101581..032774eb061e1 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -63,17 +63,13 @@ install_linux_image () {
 	fi
 
 	${MAKE} -f ${srctree}/Makefile INSTALL_MOD_PATH="${pdir}" modules_install
-	if is_enabled CONFIG_MODULES; then
-		rm -f "${pdir}/lib/modules/${KERNELRELEASE}/build"
-		rm -f "${pdir}/lib/modules/${KERNELRELEASE}/source"
-		if [ "${SRCARCH}" = um ] ; then
-			mkdir -p "${pdir}/usr/lib/uml/modules"
-			mv "${pdir}/lib/modules/${KERNELRELEASE}" "${pdir}/usr/lib/uml/modules/${KERNELRELEASE}"
-		fi
-	fi
+	rm -f "${pdir}/lib/modules/${KERNELRELEASE}/build"
+	rm -f "${pdir}/lib/modules/${KERNELRELEASE}/source"
 
 	# Install the kernel
 	if [ "${ARCH}" = um ] ; then
+		mkdir -p "${pdir}/usr/lib/uml/modules"
+		mv "${pdir}/lib/modules/${KERNELRELEASE}" "${pdir}/usr/lib/uml/modules/${KERNELRELEASE}"
 		mkdir -p "${pdir}/usr/bin" "${pdir}/usr/share/doc/${pname}"
 		cp System.map "${pdir}/usr/lib/uml/modules/${KERNELRELEASE}/System.map"
 		cp ${KCONFIG_CONFIG} "${pdir}/usr/share/doc/${pname}/config"
-- 
2.39.2



