Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A3C175A8D;
	Sat, 28 Feb 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301387; cv=none; b=VJBvSV4UeJomLoHO9b3NJ/dZRP2KCvZa12Sh1svrMJGq9wyZEgroa6vaSnMTSD27FoqCCqQji0UHoa0HPb4RwU+SA4Vza7M+SCRhy9So4oRUz5TnJ4BxNCRxjFfBrWAeBrc0gyrBH9Jt5PoY29kMoXhtE4OfFE5y09lJct7sRTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301387; c=relaxed/simple;
	bh=GixZ2G0ffOx1s7wZR8pzuFnmHFf0vJmVOO/gIRFMUHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mf4Ew0ErWCvjLTcX+6/QOx2ncwbu9Sl8o7x+MlwyBySjfgvnMh4DZfQTpzltPsklJQod17ax/EEpOfUk9XTarwLS31HF/ArqzBsD8NhY50TsJtvVj4qalP81sejtpdwWs5UMWCrj6qKMOEfS69eclKQkUhPoKZC1Aw+Lrhd/E7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsrcO1s/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsrcO1s/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39C3C19423;
	Sat, 28 Feb 2026 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301387;
	bh=GixZ2G0ffOx1s7wZR8pzuFnmHFf0vJmVOO/gIRFMUHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsrcO1s//BqBEVefYEAtgHQo0IwTkxCHFonryc1Hk8GjPcY6cwTBQw7+P5kMYIuFL
	 S92KzqwHR6vk1Whr5tHUXsmOjUvvNDaGx6oIZJChfAEhRdnZfUdpRJgHmbiLYr8n3Q
	 hwwe1y7akMnyAP8O2FB757cDzJzTo74fuQ141Fd/KrlNglu9v9QNpt7jwPOLS3rAkt
	 1dHA9G0unjx7P4cCoYOQZ4r4U+QqFrjjdsh9GXvLsIUYpynEwBzMz/nin65H2jS9+A
	 XEclWpAdqIL/wGGvBODIPGSg23BnIN78KrgiAjwRCj/mJArYSNH8Z0l5qrfatOkTYG
	 2s+l7PNHxaOjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	stable@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 576/752] docs: kdoc: avoid error_count overflows
Date: Sat, 28 Feb 2026 12:44:47 -0500
Message-ID: <20260228174750.1542406-576-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 802774d8539fa73487190ec45438777a3c38d424 ]

The glibc library limits the return code to 8 bits. We need to
stick to this limit when using sys.exit(error_count).

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <233d1674db99ed8feb405a2f781de350f0fba0ac.1768823489.git.mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kernel-doc.py | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/scripts/kernel-doc.py b/scripts/kernel-doc.py
index d9fe2bcbd39cc..a6bb180b13d65 100755
--- a/scripts/kernel-doc.py
+++ b/scripts/kernel-doc.py
@@ -116,6 +116,8 @@ SRC_DIR = os.path.dirname(os.path.realpath(__file__))
 
 sys.path.insert(0, os.path.join(SRC_DIR, LIB_DIR))
 
+WERROR_RETURN_CODE = 3
+
 DESC = """
 Read C language source or header FILEs, extract embedded documentation comments,
 and print formatted documentation to standard output.
@@ -176,7 +178,21 @@ class MsgFormatter(logging.Formatter):
         return logging.Formatter.format(self, record)
 
 def main():
-    """Main program"""
+    """
+    Main program.
+
+    By default, the return value is:
+
+    - 0: success or Python version is not compatible with
+      kernel-doc.  If -Werror is not used, it will also
+      return 0 if there are issues at kernel-doc markups;
+
+    - 1: an abnormal condition happened;
+
+    - 2: argparse issued an error;
+
+    - 3: -Werror is used, and one or more unfiltered parse warnings happened.
+    """
 
     parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter,
                                      description=DESC)
@@ -323,16 +339,12 @@ def main():
 
     if args.werror:
         print("%s warnings as errors" % error_count)    # pylint: disable=C0209
-        sys.exit(error_count)
+        sys.exit(WERROR_RETURN_CODE)
 
     if args.verbose:
         print("%s errors" % error_count)                # pylint: disable=C0209
 
-    if args.none:
-        sys.exit(0)
-
-    sys.exit(error_count)
-
+    sys.exit(0)
 
 # Call main method
 if __name__ == "__main__":
-- 
2.51.0

