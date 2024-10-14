Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60E120EB;
	Mon, 14 Oct 2024 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916820; cv=none; b=nBLlDBXWYYw/ylefdZAfy+geWFED/z9IUQiOP2eaP4F4I2nDMeAYJ251BVnh8MiijfO4YDlOVa3F07d0gHFIr404+Qb9wPR4g+zLbFWYVDbL9gG3iE/leAtpE5HbgVL6JDGHfMh4F9Y9U5GQdedXBF2eDmAI2O3/oOWXxuto5xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916820; c=relaxed/simple;
	bh=RB0YxHobD9reai2yXlw8L6qyrJTMHgKpnb+PPksrqOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyYcuT3lsVxsk9KCof3WTVW10A4BOjD+pRvu2p7ZkunRgJQwZkk26WhuIiUM6+KL8c5eO7TZfMVrF/PKN423+XD5cIv1HfqIU0vj9vRz2tP21+JfB2db9jZ5PAL5tCR1rVZp00BrqVd51hPHOqyNGr1M8jur61DKcpEGY1EpIGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKbt24yb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKbt24yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E90C4CEC3;
	Mon, 14 Oct 2024 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916820;
	bh=RB0YxHobD9reai2yXlw8L6qyrJTMHgKpnb+PPksrqOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKbt24ybTbBaz4D+UYHzAZ2u1T0v4mOcBDhM2aEDURDeh5LDnjoXxpEXGLvcpX9X9
	 RgsVQSdR1V35KDzjrAcRcfXx0sFRZLLEzJeYAbGo3wtOol6P1y5TdjvK95+1TAvGQn
	 Pa1PUp3kbzPla3K0jpZp/XAWO+QuxtJZvgyRwEtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Poirier <bpoirier@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/213] selftests: Introduce Makefile variable to list shared bash scripts
Date: Mon, 14 Oct 2024 16:19:08 +0200
Message-ID: <20241014141044.632750239@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit 2a0683be5b4c9829e8335e494a21d1148e832822 ]

Some tests written in bash source other files in a parent directory. For
example, drivers/net/bonding/dev_addr_lists.sh sources
net/forwarding/lib.sh. If a subset of tests is exported and run outside the
source tree (for example by using `make -C tools/testing/selftests gen_tar
TARGETS="drivers/net/bonding"`), these other files must be made available
as well.

Commit ae108c48b5d2 ("selftests: net: Fix cross-tree inclusion of scripts")
addressed this problem by symlinking and copying the sourced files but this
only works for direct dependencies. Commit 25ae948b4478 ("selftests/net:
add lib.sh") changed net/forwarding/lib.sh to source net/lib.sh. As a
result, that latter file must be included as well when the former is
exported. This was not handled and was reverted in commit 2114e83381d3
("selftests: forwarding: Avoid failures to source net/lib.sh"). In order to
allow reinstating the inclusion of net/lib.sh from net/forwarding/lib.sh,
add a mechanism to list dependent files in a new Makefile variable and
export them. This allows sourcing those files using the same expression
whether tests are run in-tree or exported.

Dependencies are not resolved recursively so transitive dependencies must
be listed in TEST_INCLUDES. For example, if net/forwarding/lib.sh sources
net/lib.sh; the Makefile related to a test that sources
net/forwarding/lib.sh from a parent directory must list:
TEST_INCLUDES := \
	../../../net/forwarding/lib.sh \
	../../../net/lib.sh

v2:
Fix rst syntax in Documentation/dev-tools/kselftest.rst (Jakub Kicinski)

v1 (from RFC):
* changed TEST_INCLUDES to take relative paths, like other TEST_* variables
  (Vladimir Oltean)
* preserved common "$(MAKE) OUTPUT=... -C ... target" ordering in Makefile
  (Petr Machata)

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/dev-tools/kselftest.rst | 12 ++++++++++++
 tools/testing/selftests/Makefile      |  7 ++++++-
 tools/testing/selftests/lib.mk        | 19 +++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
index deede972f2547..3ae1b3677d7f3 100644
--- a/Documentation/dev-tools/kselftest.rst
+++ b/Documentation/dev-tools/kselftest.rst
@@ -255,9 +255,21 @@ Contributing new tests (details)
 
    TEST_PROGS_EXTENDED, TEST_GEN_PROGS_EXTENDED mean it is the
    executable which is not tested by default.
+
    TEST_FILES, TEST_GEN_FILES mean it is the file which is used by
    test.
 
+   TEST_INCLUDES is similar to TEST_FILES, it lists files which should be
+   included when exporting or installing the tests, with the following
+   differences:
+
+    * symlinks to files in other directories are preserved
+    * the part of paths below tools/testing/selftests/ is preserved when
+      copying the files to the output directory
+
+   TEST_INCLUDES is meant to list dependencies located in other directories of
+   the selftests hierarchy.
+
  * First use the headers inside the kernel source and/or git repo, and then the
    system headers.  Headers for the kernel release as opposed to headers
    installed by the distro on the system should be the primary focus to be able
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 697f13bbbc321..5b61b8bb29f84 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -184,6 +184,8 @@ run_tests: all
 	@for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests \
+				SRC_PATH=$(shell readlink -e $$(pwd)) \
+				OBJ_PATH=$(BUILD)                   \
 				O=$(abs_objtree);		    \
 	done;
 
@@ -234,7 +236,10 @@ ifdef INSTALL_PATH
 	@ret=1;	\
 	for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
-		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install \
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install \
+				INSTALL_PATH=$(INSTALL_PATH)/$$TARGET \
+				SRC_PATH=$(shell readlink -e $$(pwd)) \
+				OBJ_PATH=$(INSTALL_PATH) \
 				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
 		ret=$$((ret * $$?));		\
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index a8f0442a36bca..01db65c0e84ca 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -77,11 +77,29 @@ define RUN_TESTS
 	run_many $(1)
 endef
 
+define INSTALL_INCLUDES
+	$(if $(TEST_INCLUDES), \
+		relative_files=""; \
+		for entry in $(TEST_INCLUDES); do \
+			entry_dir=$$(readlink -e "$$(dirname "$$entry")"); \
+			entry_name=$$(basename "$$entry"); \
+			relative_dir=$${entry_dir#"$$SRC_PATH"/}; \
+			if [ "$$relative_dir" = "$$entry_dir" ]; then \
+				echo "Error: TEST_INCLUDES entry \"$$entry\" not located inside selftests directory ($$SRC_PATH)" >&2; \
+				exit 1; \
+			fi; \
+			relative_files="$$relative_files $$relative_dir/$$entry_name"; \
+		done; \
+		cd $(SRC_PATH) && rsync -aR $$relative_files $(OBJ_PATH)/ \
+	)
+endef
+
 run_tests: all
 ifdef building_out_of_srctree
 	@if [ "X$(TEST_PROGS)$(TEST_PROGS_EXTENDED)$(TEST_FILES)" != "X" ]; then \
 		rsync -aq --copy-unsafe-links $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(OUTPUT); \
 	fi
+	@$(INSTALL_INCLUDES)
 	@if [ "X$(TEST_PROGS)" != "X" ]; then \
 		$(call RUN_TESTS, $(TEST_GEN_PROGS) $(TEST_CUSTOM_PROGS) \
 				  $(addprefix $(OUTPUT)/,$(TEST_PROGS))) ; \
@@ -111,6 +129,7 @@ endef
 install: all
 ifdef INSTALL_PATH
 	$(INSTALL_RULE)
+	$(INSTALL_INCLUDES)
 else
 	$(error Error: set INSTALL_PATH to use install)
 endif
-- 
2.43.0



