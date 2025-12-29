Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D875D255F2D;
	Mon, 29 Dec 2025 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024919; cv=none; b=nhJ/Y74gDiLrPKcg9ZnoxwaUVBD42/1+MoNP+TQIJyH0oC4DrIsOl68t242g9UmhWxixRN2zvHZy6G2MPpldkhaey21xzWANqc+4HbbEw2t2/hAC6/1hjsvICMZ2n9k718EVmk364QlzB0Tn8hdriE/JtN9S5cw7+Bt3AJDZxf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024919; c=relaxed/simple;
	bh=EZiq/5Kpjvp4QSsUv0gNhkDdM9FyfY8ar2GwXnMyTvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+UYmyDnNk1TIeDm9o0IGEXzW4XZfXBWLbdMcoXmsqhlE+TKYjL/eO4P058LSo+0whlP0u3I4IVlcZfHfnE4ZMC1/jWZgb0n8q9UAsaa80kyKA8JWAl4ScTDcLafXXFRMalLc6DDtYUeYJdVkS9duVFaFCo9mRIYra0wqCveM9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsgqbOSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsgqbOSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609B0C4CEF7;
	Mon, 29 Dec 2025 16:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024919;
	bh=EZiq/5Kpjvp4QSsUv0gNhkDdM9FyfY8ar2GwXnMyTvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsgqbOSm0zBZCNY36P4MYA7xYc5RPGgZeBFsOHlOpNPhmMNloAQN06pBMAKty3UD/
	 5fsQNjQKtPfK50VmtASkixTSwUGB85+JLWFG1eGOludxBfbJUgWEQONyIwJrNgRv8P
	 EIGqsWXl+5OYmLfVN3mLnwMwE5/vO6zkZUWNndp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/430] scripts: kdoc_parser.py: warn about Python version only once
Date: Mon, 29 Dec 2025 17:07:05 +0100
Message-ID: <20251229160725.010641994@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit ade9b9576e2f000fb2ef0ac3bcd26e1167fd813b ]

When running kernel-doc over multiple documents, it emits
one error message per file with is not what we want:

	$ python3.6 scripts/kernel-doc.py . --none
	...
	Warning: ./include/trace/events/swiotlb.h:0 Python 3.7 or later is required for correct results
	Warning: ./include/trace/events/iommu.h:0 Python 3.7 or later is required for correct results
	Warning: ./include/trace/events/sock.h:0 Python 3.7 or later is required for correct results
	...

Change the logic to warn it only once at the library:

	$ python3.6 scripts/kernel-doc.py . --none
	Warning: Python 3.7 or later is required for correct results
	Warning: ./include/cxl/features.h:0 Python 3.7 or later is required for correct results

When running from command line, it warns twice, but that sounds
ok.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Message-ID: <68e54cf8b1201d1f683aad9bc710a99421910356.1758196090.git.mchehab+huawei@kernel.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/lib/kdoc/kdoc_parser.py | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/lib/kdoc/kdoc_parser.py b/scripts/lib/kdoc/kdoc_parser.py
index 2376f180b1fa9..89d920e0b65ca 100644
--- a/scripts/lib/kdoc/kdoc_parser.py
+++ b/scripts/lib/kdoc/kdoc_parser.py
@@ -350,6 +350,7 @@ class KernelEntry:
             self.section = SECTION_DEFAULT
             self._contents = []
 
+python_warning = False
 
 class KernelDoc:
     """
@@ -383,9 +384,13 @@ class KernelDoc:
         # We need Python 3.7 for its "dicts remember the insertion
         # order" guarantee
         #
-        if sys.version_info.major == 3 and sys.version_info.minor < 7:
+        global python_warning
+        if (not python_warning and
+            sys.version_info.major == 3 and sys.version_info.minor < 7):
+
             self.emit_msg(0,
                           'Python 3.7 or later is required for correct results')
+            python_warning = True
 
     def emit_msg(self, ln, msg, warning=True):
         """Emit a message"""
-- 
2.51.0



