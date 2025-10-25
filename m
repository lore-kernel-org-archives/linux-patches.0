Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC45030594F;
	Sat, 25 Oct 2025 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408829; cv=none; b=GwBtA7w5c55DOlvyuYLFOgjJQdz3sQb5t2xdp6yEVUJOcyGerfkasCwU1dYjInTBjt8OiuOpJaD/QHtz+wBFqMrKVIbaaFJf9VZJApaNEVZap7eeTBxyVeBWN4GN8QaIN11QvKeqQ0CbA5bYCQLx/Ts/IktmLTfIX5lINfTsK+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408829; c=relaxed/simple;
	bh=z29pwda9JUHRXvjAYjV3FOvlL2SuP9kPlf19QThs3SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7lmxRRnFQ5/u1hqzR69f4pvJazT3jIvIn9r6O5XN0tdTxoFX5OwCF3ZYkWURAshVIIBpsGmkWFXt4OrxdojyJoXBgG5E/J8uY2spiRkoiSI4T0LEeP6lXlDuCAPsd8NBqyQGTKZ3IVxjE+1I/cw+80yHMu+KyfevbAI1VUjN7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vp4XBYMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vp4XBYMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA7BC4CEFB;
	Sat, 25 Oct 2025 16:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408828;
	bh=z29pwda9JUHRXvjAYjV3FOvlL2SuP9kPlf19QThs3SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vp4XBYMG+Idf96d1OQvM47apTqnO5V4fL0JzI1DXy5j4FRhc52nZCVziPGkBeVpw1
	 1BiBE7RptOn/ndFFEACR2GzGVrJ0iIGpkirYOU8XvDuATYmcrjWgHJB6T2m6BbPikw
	 j5GMKeeTe/KwdyG1NyI+txFDfokqlFLPhidGqQWw//s8bBX8mttinoi3+0aSnnPOZ9
	 Elnm+yXYV2lWiE5bYv0RvDCQ3E0iXmFjISqKzxmkcyacSFpRNMznqiQ/6D7UCh95PH
	 sxM8Fh22UKyInOiwBL/m9ulanrljbnyqV5jHIxMo/y8lQjYVewa3Cn+CeQkjgKlbto
	 B0bOxathTpoBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] docs: kernel-doc: avoid script crash on ancient Python
Date: Sat, 25 Oct 2025 11:55:21 -0400
Message-ID: <20251025160905.3857885-90-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

Explanation

- Fixes real build bug
  - Current script uses f-strings, which cause a SyntaxError on Python <
    3.6 before any version check runs, breaking builds that invoke
    kernel-doc during compilation.
  - Evidence:
    - f-strings in `scripts/kernel-doc.py:311` and `scripts/kernel-
      doc.py:315`:
      - `print(f"{error_count} warnings as errors")`
      - `print(f"{error_count} errors")`
    - Early top-level imports pull in modules that also use modern
      syntax (and f-strings), compounding parse failures under old
      Python:
      - `scripts/kernel-doc.py:110-111` imports
        `kdoc_files`/`kdoc_output` at module import time.
      - `scripts/lib/kdoc/kdoc_parser.py` contains many f-strings (e.g.,
        `scripts/lib/kdoc/kdoc_parser.py:838`,
        `scripts/lib/kdoc/kdoc_parser.py:1181`,
        `scripts/lib/kdoc/kdoc_parser.py:1382`).
  - This breaks kernels built on systems where `python3` is 3.2–3.5
    (still seen on older distros). The kernel build invokes kernel-doc
    with `-none` in at least one path, so this is a real build-time
    problem:
    - `drivers/gpu/drm/i915/Makefile:429` runs:
      `$(srctree)/scripts/kernel-doc -none -Werror $<; touch $@`

- What the patch changes (and why it fixes it)
  - Defers imports of kernel-doc internals until after Python version
    check:
    - Changes from top-level imports (`scripts/kernel-doc.py:110-111`)
      to importing only after confirming `python_ver >= (3,6)` (per the
      diff). This prevents parsing `kdoc_*` modules under ancient
      Python.
  - Removes f-strings from this file so ancient Python can parse it:
    - Replaces f-strings with `%` formatting when printing counts (per
      diff; replaces the lines at `scripts/kernel-doc.py:311` and
      `scripts/kernel-doc.py:315`).
  - Adjusts behavior under old Python to avoid build breakage for the
    `--none` case only:
    - Previously: for Python < 3.6, the script logged a warning and
      unconditionally exited 0 (`scripts/kernel-doc.py:274-279`). That
      intent was to “avoid breaking compilation”, but it could not work
      on 3.2–3.5 due to parse errors.
    - Now: if Python < 3.6 and `--none` is used, it logs an error and
      exits 0 (“skipping checks”), preserving successful compilation. If
      `--none` is not used, it exits non-zero with a clear message. This
      avoids silent success when actually trying to generate docs and
      aligns behavior to intent in the commit message.

- Scope and risk
  - Small, contained change to documentation tooling only
    (`scripts/kernel-doc.py`).
  - No architectural changes and no impact on the running kernel.
  - Behavioral change only affects the corner-case of Python < 3.6:
    - For `--none`, it keeps builds succeeding (previous intent), now
      actually working because parse errors are avoided.
    - For real doc generation on ancient Python, it now fails explicitly
      instead of silently returning 0 with no output — a safer and
      clearer behavior.
  - Imports are moved inside `main()` after version gating; otherwise
    functionality is unchanged for supported Python versions.

- Stable backport suitability
  - Fixes a concrete build-time crash/regression on older build
    environments when the kernel build triggers kernel-doc with `-none`.
  - Minimal risk and fully confined to a script in `scripts/`.
  - No new features or interfaces introduced.
  - Note on applicability: only relevant to trees that already have the
    Python-based `scripts/kernel-doc`/`scripts/kernel-doc.py`. Trees
    that still use the Perl `scripts/kernel-doc` are unaffected by this
    bug and do not need this patch.

Conclusion: This is a targeted, low-risk build fix to avoid spurious
failures on older Python during kernel builds that call `kernel-doc
-none`. It meets stable rules for important bugfixes with minimal risk
and should be backported (to branches with the Python kernel-doc
script).

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

