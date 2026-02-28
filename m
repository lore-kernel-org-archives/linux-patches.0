Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60794373BF2;
	Sat, 28 Feb 2026 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301547; cv=none; b=PSmdLxqftpbbjaqvV04N/+B215i6yLA68P+HW1//iiBjvvfNQR7CFRwwrD87mXLldrU4bWB8QP84cAkQByv5z4g2gQa9F0fujV+QAdRcQNfKP+2RGnRcR74Da5qPI9Z5ntFao/kLhFJQWcxTLct/Vkb5PcbcsB978s0vFac9DI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301547; c=relaxed/simple;
	bh=vWWgYDOWrP/1sJh38suuQpb9ZQiOHx8/B0uMDWh4wBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CdyofGnI74BhXx9pkajmF34puLhmu1zZgmNf4ImOPoL/RbYcrhnsmfxyClsRBDAsuxVwp3ZflOqmXT2MPoKgACufTS0bk9Mgwcdvyh8fnlNyL4IjMW863vC3P9vqJZIIdxnV0KhkSFInW1BEpsTKI4hqjbQugeFsh1rJOXht47M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rsuf9J1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rsuf9J1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF28EC19423;
	Sat, 28 Feb 2026 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301547;
	bh=vWWgYDOWrP/1sJh38suuQpb9ZQiOHx8/B0uMDWh4wBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rsuf9J1SKVBaTjNc5E9Ab5vPTbuHq5DK4q9xOUzoOz3Jzzbefwdhrxzm0iddWLdPK
	 QnKwW+hEmabAYBlInAgrKJODkj+Z1zdfgu7+J0WIKmVZhn9ZnEbUUD4xwl+UFH4/T8
	 McOVlbODCJOQXGo/RLWMn5hjQDJ+dX8IcFN8WuKKni4Dt20eerekgrWJ8QzrsAr25/
	 EQTdpCulWQt0t4RdWYCK4TF0XFETBNvSNN+kNJNQM2zK2IyxygOtNxbPQqmfoHmNVa
	 DplI1JGK/dPblRc2y2DyiIDH2/o5bmf7ef1utnW5l+QLldM52P1Oya7V9xGhfwY/Ud
	 Qe4qxqFdUsr9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nathan Chancellor <nathan@kernel.org>,
	stable@vger.kernel.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 730/752] kbuild: rpm-pkg: Disable automatic requires for manual debuginfo package
Date: Sat, 28 Feb 2026 12:47:21 -0500
Message-ID: <20260228174750.1542406-730-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit f94711255a73d8938cf3bb405a0af3a4d2700ed1 ]

Stefano reports that after commit 62089b804895 ("kbuild: rpm-pkg:
Generate debuginfo package manually"), building with an rpm package
using rpm 4.20.0 fails with:

  RPM build errors:
      Dependency tokens must begin with alpha-numeric, '_' or '/': #�) = 0x0d000002
      Dependency tokens must begin with alpha-numeric, '_' or '/': �) = 0x0d000000
      Dependency tokens must begin with alpha-numeric, '_' or '/': ) = 0x7c0e000000
      Unknown rich dependency op 'Hat': (Red Hat 15.2.1-7)) = 0x3130363230322000
      Unknown rich dependency op 'Hat': (Red Hat 15.2.1-7)) = 0x4728203a43434800
      Unknown rich dependency op 'Hat': (Red Hat 15.2.1-7)) = 0x3130363230322000
      Unknown rich dependency op 'Hat': (Red Hat 15.2.1-7)) = 0x4728203a43434800

This error comes from the automatic requirements feature of rpm. The
-debuginfo subpackage has no dependencies, so disable this feature with
'AutoReq: 0' for this subpackage, avoiding the error. This matches the
official %_debug_template macro that rpm provides. While automatic
provides should be default enabled, be explicit like %_debug_template
does.

Additionally, while in the area, add the manual debug information
package to the Development/Debug group, further aligning with
%_debug_template.

Cc: stable@vger.kernel.org
Fixes: 62089b804895 ("kbuild: rpm-pkg: Generate debuginfo package manually")
Reported-by: Stefano Garzarella <sgarzare@redhat.com>
Closes: https://lore.kernel.org/CAGxU2F7FFNgb781_A7a1oL63n9Oy8wsyWceKhUpeZ6mLk=focw@mail.gmail.com/
Tested-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260216-improve-manual-debuginfo-template-v1-1-e584b3f8d3be@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/kernel.spec | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/package/kernel.spec b/scripts/package/kernel.spec
index bccf58bdd45fd..b3c956205af00 100644
--- a/scripts/package/kernel.spec
+++ b/scripts/package/kernel.spec
@@ -48,6 +48,9 @@ against the %{version} kernel package.
 %if %{with_debuginfo_manual}
 %package debuginfo
 Summary: Debug information package for the Linux kernel
+Group: Development/Debug
+AutoReq: 0
+AutoProv: 1
 %description debuginfo
 This package provides debug information for the kernel image and modules from the
 %{version} package.
-- 
2.51.0

