Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AF832E696;
	Mon, 20 Apr 2026 15:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699924; cv=none; b=pQbx5CP8Tk4U+g8fGmOmCID+LRh8E9qcPEYRsW/ul6NraNj/v7HEkXvx4AXCp28FObjPDNVS9Lt/nEuBr+QMbwtUTPrqTPjH7CCXfVfEKeWMeChkKoFeoy4UEpm4SJTVbnam8JxG8TeYSNlDAj0XoXMmnDN3WfMt2kbkoxiojKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699924; c=relaxed/simple;
	bh=TaEuWs9kG3ZqgUVNnD5WDfyZVC+dtG0BAasQmf4ErNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reVJY0iQFJftvz/mlw4C7pM1VWC4WO0XUqKjYHFLijwYI0//5rIN62ujBCCklpvUhilvU3jMnSgv3YZJNn4me7J1AhHMTpL2QIiOKjAhHCJkpj/0rhWr4cMBRhDwzuHo981lqvejJlgGY+SDypg2FDCcWq54HfguE/oriOsZTBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnsrccYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnsrccYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6FAC19425;
	Mon, 20 Apr 2026 15:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699924;
	bh=TaEuWs9kG3ZqgUVNnD5WDfyZVC+dtG0BAasQmf4ErNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnsrccYejkbogkTfk0+023Of5aREN4+4thg+2pgfSC2m9SuiayGwT6eeVguiF5VN1
	 hAlUcN2+U0v6RtnNdzsTAi7osm3Zh3A9TkbmRuqmUWJNsvZfoRnX9UjAP+2Zjdi5v9
	 AdwXgphsSDFxkeYknWmAVJc1LGk3RzlVsfp29B/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Fiona Behrens <me@kloenk.dev>,
	Trevor Gross <tmgross@umich.edu>,
	Tamir Duberstein <tamird@kernel.org>
Subject: [PATCH 7.0 33/76] scripts: generate_rust_analyzer.py: avoid FD leak
Date: Mon, 20 Apr 2026 17:41:44 +0200
Message-ID: <20260420153912.026695766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@kernel.org>

commit 9b4744d8eda2824041064a5639ccbb079850914d upstream.

Use `pathlib.Path.read_text()` to avoid leaking file descriptors.

Fixes: 8c4555ccc55c ("scripts: add `generate_rust_analyzer.py`")
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Fiona Behrens <me@kloenk.dev>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Link: https://patch.msgid.link/20260127-rust-analyzer-fd-leak-v2-1-1bb55b9b6822@kernel.org
Signed-off-by: Tamir Duberstein <tamird@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -190,9 +190,10 @@ def generate_crates(srctree, objtree, sy
 
     def is_root_crate(build_file, target):
         try:
-            return f"{target}.o" in open(build_file).read()
+            contents = build_file.read_text()
         except FileNotFoundError:
             return False
+        return f"{target}.o" in contents
 
     # Then, the rest outside of `rust/`.
     #


