Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497C3303CAC;
	Tue, 11 Nov 2025 01:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823290; cv=none; b=RK+tXUML0EItG2yD7c84giCmfU5WU5YHoKVWvFThAEZFLHE3UYX/2FeSlYtnGXC9+h690CmwrmUItwYEbEyi3vvLa08Ngs2zKVJIDT7sKur+u969zR6uM1xQ1kmPMYB151Fo3qy05T1KIyW1k36lQyqWXvHJOIXuNyJEg4wTO1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823290; c=relaxed/simple;
	bh=ajYPGhfw60txX942CdzmsRFF4Y1q7FfqhqsZZHxX5E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u64SHJyse3SzfLP/wJdJhEAYhKsS9x2gE3Mdk1Cmi3+ZJlKKOTrvoVzoBMCxiZMlc/XJ5tfFUrn88xdGD418uQN49AGvDQ92RhFYcohf6vFQPF4f5sVVJE1fDsn9R1gvvdVIqh5u3cuzSh61BOZCcPOq4rtP2okZvYlKaFiE9YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QT2luHl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QT2luHl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF0EC4AF0B;
	Tue, 11 Nov 2025 01:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823289;
	bh=ajYPGhfw60txX942CdzmsRFF4Y1q7FfqhqsZZHxX5E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QT2luHl8cmdN1inc4zpyKdP4S/mKmWyPZyTgkjW4t1FPwQvUrEHTp2y5LmYuyZtQB
	 Ifas0WVkW0CwRq4c0PUfKK1ssgUmhClx8YRed2Aaud2g0G0TgQ/vkLqcczxLo0+gbb
	 7/ComXhBkZ2rr1VDSG/QkY7xEMb4cMmU/PYxsYl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 269/849] docs: kernel-doc: avoid script crash on ancient Python
Date: Tue, 11 Nov 2025 09:37:19 +0900
Message-ID: <20251111004542.934930071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit fc973dcd73f242480c61eccb1aa7306adafd2907 ]

While we do need at least 3.6 for kernel-doc to work, and at least
3.7 for it to output functions and structs with parameters at the
right order, let the python binary be compatible with legacy
versions.

The rationale is that the Kernel build nowadays calls kernel-doc
with -none on some places. Better not to bail out when older
versions are found.

With that, potentially this will run with python 2.7 and 3.2+,
according with vermin:

	$ vermin --no-tips -v ./scripts/kernel-doc
	Detecting python files..
	Analyzing using 24 processes..
	2.7, 3.2     /new_devel/v4l/docs/scripts/kernel-doc
	Minimum required versions: 2.7, 3.2

3.2 minimal requirement is due to argparse.

The minimal version I could check was version 3.4
(using anaconda). Anaconda doesn't support 3.2 or 3.3
anymore, and 3.2 doesn't even compile (I tested compiling
Python 3.2 on Fedora 42 and on Fedora 32 - no show).

With 3.4, the script didn't crash and emitted the right warning:

	$ conda create -n py34 python=3.4
	$ conda activate py34
	python --version
        Python 3.4.5
        $ python ./scripts/kernel-doc --none include/media
	Error: Python 3.6 or later is required by kernel-doc
	$ conda deactivate

	$ python --version
	Python 3.13.5
        $ python ./scripts/kernel-doc --none include/media
	(no warnings and script ran properly)

Supporting 2.7 is out of scope, as it is EOL for 5 years, and
changing shebang to point to "python" instead of "python3"
would have a wider impact.

I did some extra checks about the differences from 3.2 and
3.4, and didn't find anything that would cause troubles:

	grep -rE "yield from|asyncio|pathlib|async|await|enum" scripts/kernel-doc

Also, it doesn't use "@" operator. So, I'm confident that it
should run (producing the exit warning) since Python 3.2.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/87d55e76b0b1391cb7a83e3e965dbddb83fa9786.1753806485.git.mchehab+huawei@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kernel-doc.py | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/scripts/kernel-doc.py b/scripts/kernel-doc.py
index fc3d46ef519f8..d9fe2bcbd39cc 100755
--- a/scripts/kernel-doc.py
+++ b/scripts/kernel-doc.py
@@ -2,8 +2,17 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright(c) 2025: Mauro Carvalho Chehab <mchehab@kernel.org>.
 #
-# pylint: disable=C0103,R0915
-#
+# pylint: disable=C0103,R0912,R0914,R0915
+
+# NOTE: While kernel-doc requires at least version 3.6 to run, the
+#       command line should work with Python 3.2+ (tested with 3.4).
+#       The rationale is that it shall fail gracefully during Kernel
+#       compilation with older Kernel versions. Due to that:
+#       - encoding line is needed here;
+#       - no f-strings can be used on this file.
+#       - the libraries that require newer versions can only be included
+#         after Python version is checked.
+
 # Converted from the kernel-doc script originally written in Perl
 # under GPLv2, copyrighted since 1998 by the following authors:
 #
@@ -107,9 +116,6 @@ SRC_DIR = os.path.dirname(os.path.realpath(__file__))
 
 sys.path.insert(0, os.path.join(SRC_DIR, LIB_DIR))
 
-from kdoc_files import KernelFiles                      # pylint: disable=C0413
-from kdoc_output import RestFormat, ManFormat           # pylint: disable=C0413
-
 DESC = """
 Read C language source or header FILEs, extract embedded documentation comments,
 and print formatted documentation to standard output.
@@ -273,14 +279,22 @@ def main():
 
     python_ver = sys.version_info[:2]
     if python_ver < (3,6):
-        logger.warning("Python 3.6 or later is required by kernel-doc")
+        # Depending on Kernel configuration, kernel-doc --none is called at
+        # build time. As we don't want to break compilation due to the
+        # usage of an old Python version, return 0 here.
+        if args.none:
+            logger.error("Python 3.6 or later is required by kernel-doc. skipping checks")
+            sys.exit(0)
 
-        # Return 0 here to avoid breaking compilation
-        sys.exit(0)
+        sys.exit("Python 3.6 or later is required by kernel-doc. Aborting.")
 
     if python_ver < (3,7):
         logger.warning("Python 3.7 or later is required for correct results")
 
+    # Import kernel-doc libraries only after checking Python version
+    from kdoc_files import KernelFiles                  # pylint: disable=C0415
+    from kdoc_output import RestFormat, ManFormat       # pylint: disable=C0415
+
     if args.man:
         out_style = ManFormat(modulename=args.modulename)
     elif args.none:
@@ -308,11 +322,11 @@ def main():
         sys.exit(0)
 
     if args.werror:
-        print(f"{error_count} warnings as errors")
+        print("%s warnings as errors" % error_count)    # pylint: disable=C0209
         sys.exit(error_count)
 
     if args.verbose:
-        print(f"{error_count} errors")
+        print("%s errors" % error_count)                # pylint: disable=C0209
 
     if args.none:
         sys.exit(0)
-- 
2.51.0



