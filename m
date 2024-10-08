Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3211DED47;
	Tue,  8 Oct 2024 13:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392827; cv=none; b=B0Qgt4fQfxhdZXEqUnhzQhXDyWgA/ThokT+NsEBSj2izq7SG6dvHQixd/pqfisH6vtiSORg72IUs8cAi+mCKPQP9aE3602iGfhclfyWUbcl50J+xIkFvS9Jsqc8NMHJh4wQYV9wfx25NaRuF4L542KYK5vxcxYTnI18i6bk7mM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392827; c=relaxed/simple;
	bh=B9vTroPqI8xOOICkKtC/63dWC4PPIfolt/gBkgfkmxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGJh9WABVmRY173juDdGL7HP/l9nNGN54QQBe9oOYvNtl0Gk9o9l36niz2bjFTMMlEUft5cMawL2OV4MxMhIxM97kkX2VNUBU/oyfaXDk9ZQ5LlQ4K/v2O3yP6514Cp1aZDRPIxbgjSHrIFdcPTo/eqPWfrLAz+GWGQPfZcxijE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICS+Vw4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICS+Vw4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F33BC4CEC7;
	Tue,  8 Oct 2024 13:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392826;
	bh=B9vTroPqI8xOOICkKtC/63dWC4PPIfolt/gBkgfkmxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICS+Vw4TGx5oJHxY+inWokYhy78sHYa+OCe6Lwv0FWcL13cygcn8wctU/z/SCJAZM
	 zvsBnCSo1584cISOBlEmHuQ4MWM/u7r+Qa6VbbD3ZdtxwVWwXbEYAoVc5ylG/9cfM/
	 FnwFZpRDiAhy11OLt/nGPvG2ZMcOljioFr0PBigo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 530/558] kconfig: qconf: move conf_read() before drawing tree pain
Date: Tue,  8 Oct 2024 14:09:20 +0200
Message-ID: <20241008115723.082289053@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit da724c33b685463720b1c625ac440e894dc57ec0 ]

The constructor of ConfigMainWindow() calls show*View(), which needs
to calculate symbol values. conf_read() must be called before that.

Fixes: 060e05c3b422 ("kconfig: qconf: remove initial call to conf_changed()")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/qconf.cc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 7d239c032b3d6..959c2c78e1ef9 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1505,6 +1505,8 @@ ConfigMainWindow::ConfigMainWindow(void)
 	connect(helpText, &ConfigInfoView::menuSelected,
 		this, &ConfigMainWindow::setMenuLink);
 
+	conf_read(NULL);
+
 	QString listMode = configSettings->value("/listMode", "symbol").toString();
 	if (listMode == "single")
 		showSingleView();
@@ -1906,8 +1908,6 @@ int main(int ac, char** av)
 	configApp->connect(configApp, SIGNAL(lastWindowClosed()), SLOT(quit()));
 	configApp->connect(configApp, SIGNAL(aboutToQuit()), v, SLOT(saveSettings()));
 
-	conf_read(NULL);
-
 	v->show();
 	configApp->exec();
 
-- 
2.43.0



