Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537ED32A3DB;
	Mon, 18 Aug 2025 13:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523544; cv=none; b=cnG+BpbDu/FywFXRjcbgVB/53OwSffU1Ms9QiKmi9i6PiBK9NzIWgZTzYb2dTvlvwRMGB8mToC4oylYstP3RoLPD0igTT9vo+W5LLlaBRIMmTrZRdOjgyulDZLXRjxXhOe9DFzLGGqaSFgmIslxJZedes81gUvQpF/HnTa/FZRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523544; c=relaxed/simple;
	bh=EaaWmzqwZdPQuzrTcL/NQG6BuCkQEb3Vcqlo1Jf/BSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ub+dmgwPYe2AUW2bl26f50ZiXH3sJ3M24Lsh7DOKJUM+bXeW+PdkyDZagiwSKOFN8nqjfIVmRMq/f7h24Xrbj3textYvxExvWKAWOTzuwWb6DaAGdDDSL9F0qve9lTtoEayAcs1zISJ2AXEdg9Vkpsw3R4kvjeDc4AjcW+zd7sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJToLrVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJToLrVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7885C4CEEB;
	Mon, 18 Aug 2025 13:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523544;
	bh=EaaWmzqwZdPQuzrTcL/NQG6BuCkQEb3Vcqlo1Jf/BSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJToLrVOq41FaLlh/0wxguJxs1Gu7TFtU7nDsOVtRfaPdXZqBepBcAKt8gvadgWzC
	 JoG/T7DnRui4UaNG71Qndl+vCUTPjT/Eh6zsHDe8JN5Kx+V7DUI2yMmSW1r1dmLYMW
	 CliviD0aYjHm1j3TGTx8EamlG/yIs5GZMxc2ppW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"John Warthog9 Hawley" <warthog9@kernel.org>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 204/515] ktest.pl: Prevent recursion of default variable options
Date: Mon, 18 Aug 2025 14:43:10 +0200
Message-ID: <20250818124506.223659647@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 61f7e318e99d3b398670518dd3f4f8510d1800fc ]

If a default variable contains itself, do not recurse on it.

For example:

  ADD_CONFIG := ${CONFIG_DIR}/temp_config
  DEFAULTS
  ADD_CONFIG = ${CONFIG_DIR}/default_config ${ADD_CONFIG}

The above works because the temp variable ADD_CONFIG (is a temp because it
is created with ":=") is already defined, it will be substituted in the
variable option. But if it gets commented out:

  # ADD_CONFIG := ${CONFIG_DIR}/temp_config
  DEFAULTS
  ADD_CONFIG = ${CONFIG_DIR}/default_config ${ADD_CONFIG}

Then the above will go into a recursive loop where ${ADD_CONFIG} will
get replaced with the current definition of ADD_CONFIG which contains the
${ADD_CONFIG} and that will also try to get converted. ktest.pl will error
after 100 attempts of recursion and fail.

When replacing a variable with the default variable, if the default
variable contains itself, do not replace it.

Cc: "John Warthog9 Hawley" <warthog9@kernel.org>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/20250718202053.732189428@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index a5f7fdd0c1fb..e1d31e2aa948 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1371,7 +1371,10 @@ sub __eval_option {
 	# If a variable contains itself, use the default var
 	if (($var eq $name) && defined($opt{$var})) {
 	    $o = $opt{$var};
-	    $retval = "$retval$o";
+	    # Only append if the default doesn't contain itself
+	    if ($o !~ m/\$\{$var\}/) {
+		$retval = "$retval$o";
+	    }
 	} elsif (defined($opt{$o})) {
 	    $o = $opt{$o};
 	    $retval = "$retval$o";
-- 
2.39.5



