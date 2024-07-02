Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBD11BC08A;
	Tue,  2 Jul 2024 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940354; cv=none; b=Nospi/u27ytj0ZqJJR1oSF5/7T4oJAu3gEK74l9PQAxC1Mi8qjIalv9Qd7ueuPmEATbriyc3idm06RLOr5D54W/x1D6c91GpjTwoXgdteHXUl/HItu7RE1LU37BK/kx6WcNkRuz7jHaYw4jw0urQPBXIr+u1qAn+p0areIDWxIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940354; c=relaxed/simple;
	bh=BZTXdX8Q5VEQllcLGqCcejHQwoB1n6mTrYkZqVEYHLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFXqBMlhR2wSh5GiGkBGSx3WHh/GCZOB/kWkUaEJIJv879qZgq4xSbW94SNjRZPF5PDgEGbd1yFAaAmDvQbXZ4VFRGqs2yuAlLjjAMCYIuBRX7NJazeLDUWAY2juXHvbJtgdIV3irV5AEQWZAJ4j6RLYQkhYQm8C6ODBRXmmLYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s12Uri1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s12Uri1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDE6C116B1;
	Tue,  2 Jul 2024 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940354;
	bh=BZTXdX8Q5VEQllcLGqCcejHQwoB1n6mTrYkZqVEYHLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s12Uri1HBqJ4j0+ryDw9vqjoP+u7m2jC1SElPMxqwSNXQpqf1t5oLbEOG9x0sJ2HS
	 JEPHm6ec/NhpR900aLJ2N+07vaIMkj2zYpCpgrKIgAliG+1bDgU5TIlhDY8u1JQkEI
	 E4gXrJKC00PMtbuCY2FnE6VFGAKPddEv2GcNX8U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thayne Harbaugh <thayne@mastodonlabs.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 130/222] kbuild: Fix build target deb-pkg: ln: failed to create hard link
Date: Tue,  2 Jul 2024 19:02:48 +0200
Message-ID: <20240702170248.939516728@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thayne Harbaugh <thayne@mastodonlabs.com>

[ Upstream commit c61566538968ffb040acc411246fd7ad38c7e8c9 ]

The make deb-pkg target calls debian-orig which attempts to either
hard link the source .tar to the build-output location or copy the
source .tar to the build-output location.  The test to determine
whether to ln or cp is incorrectly expanded by Make and consequently
always attempts to ln the source .tar.  This fix corrects the escaping
of '$' so that the test is expanded by the shell rather than by Make
and appropriately selects between ln and cp.

Fixes: b44aa8c96e9e ("kbuild: deb-pkg: make .orig tarball a hard link if possible")
Signed-off-by: Thayne Harbaugh <thayne@mastodonlabs.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.package | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.package b/scripts/Makefile.package
index 38653f3e81088..bf016af8bf8ad 100644
--- a/scripts/Makefile.package
+++ b/scripts/Makefile.package
@@ -103,7 +103,7 @@ debian-orig: private version = $(shell dpkg-parsechangelog -S Version | sed 's/-
 debian-orig: private orig-name = $(source)_$(version).orig.tar$(debian-orig-suffix)
 debian-orig: mkdebian-opts = --need-source
 debian-orig: linux.tar$(debian-orig-suffix) debian
-	$(Q)if [ "$(df  --output=target .. 2>/dev/null)" = "$(df --output=target $< 2>/dev/null)" ]; then \
+	$(Q)if [ "$$(df  --output=target .. 2>/dev/null)" = "$$(df --output=target $< 2>/dev/null)" ]; then \
 		ln -f $< ../$(orig-name); \
 	else \
 		cp $< ../$(orig-name); \
-- 
2.43.0



