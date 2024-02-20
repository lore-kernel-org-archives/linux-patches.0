Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1F0151CC4;
	Tue, 20 Feb 2024 21:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462943; cv=none; b=gXUE8HfRLQwdIv7Z2eOP3lT97cIWvNx9TfIGM9Qv8XAPYyW+GEMazR2o6sAQq2GT/iTzxsPVmfkY0m6FLI1CBmgj3AeSJDmbPL1L0y19dR5AQS3LVd/EeTY9/ajd1xyZhKjg4C3WqY3YQL3TF2ZHhpBNDFoUs2PigkKGOz8sbRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462943; c=relaxed/simple;
	bh=u6bXl2srPz1L/ZW9vYHjd1ZN2uH/VRCRDTqb8G4xFG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEsq509f90sDAi4Vz1En5E2rDsgq9XO5kWoq03q3m9/Q2+HvIsyt3YPePe3T8O8Pl9ASDHRJv1houDzgjx0N5YpMMIyZ/qSttLYfb0qOCI4Vfba48YYkcKmhtf9R/qSuHmj6GB/CGszDvnWSr5BGcpaFc9b/2RyEeurpVKV6Nrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTM5rAUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTM5rAUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E63C433C7;
	Tue, 20 Feb 2024 21:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462943;
	bh=u6bXl2srPz1L/ZW9vYHjd1ZN2uH/VRCRDTqb8G4xFG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTM5rAUddqQMSGU6vxbq8TEp4u0hCK2T+hudcczh2eR5jU4DWkYc3DmdQMWhJgnWy
	 9wmfVnq1M0rDVpJPeYo44acO5UdyTB/cv/teL7TkUC61+xRNTIAlfr3tyKWz7DAXey
	 6JYdCLWBxmxtYe3c7HrNJnif3CCfrEVjQ+RoovZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 086/197] modpost: propagate W=1 build option to modpost
Date: Tue, 20 Feb 2024 21:50:45 +0100
Message-ID: <20240220204843.660299831@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

commit 20ff36856fe00879f82de71fe6f1482ca1b72334 upstream.

"No build warning" is a strong requirement these days, so you must fix
all issues before enabling a new warning flag.

We often add a new warning to W=1 first so that the kbuild test robot
blocks new breakages.

This commit allows modpost to show extra warnings only when W=1
(or KBUILD_EXTRA_WARN=1) is given.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: 846cfbeed09b ("um: Fix adding '-no-pie' for clang")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.modpost |    1 +
 scripts/mod/modpost.c    |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -44,6 +44,7 @@ modpost-args =										\
 	$(if $(CONFIG_SECTION_MISMATCH_WARN_ONLY),,-E)					\
 	$(if $(KBUILD_NSDEPS),-d $(MODULES_NSDEPS))					\
 	$(if $(CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS)$(KBUILD_NSDEPS),-N)	\
+	$(if $(findstring 1, $(KBUILD_EXTRA_WARN)),-W)					\
 	-o $@
 
 # 'make -i -k' ignores compile errors, and builds as many modules as possible.
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -41,6 +41,8 @@ static bool allow_missing_ns_imports;
 
 static bool error_occurred;
 
+static bool extra_warn;
+
 /*
  * Cut off the warnings when there are too many. This typically occurs when
  * vmlinux is missing. ('make modules' without building vmlinux.)
@@ -2290,7 +2292,7 @@ int main(int argc, char **argv)
 	LIST_HEAD(dump_lists);
 	struct dump_list *dl, *dl2;
 
-	while ((opt = getopt(argc, argv, "ei:mnT:o:awENd:")) != -1) {
+	while ((opt = getopt(argc, argv, "ei:mnT:o:aWwENd:")) != -1) {
 		switch (opt) {
 		case 'e':
 			external_module = true;
@@ -2315,6 +2317,9 @@ int main(int argc, char **argv)
 		case 'T':
 			files_source = optarg;
 			break;
+		case 'W':
+			extra_warn = true;
+			break;
 		case 'w':
 			warn_unresolved = true;
 			break;


