Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1D234DCC1;
	Tue, 26 Aug 2025 14:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217747; cv=none; b=eTXfXsZ5ojYkGxPyNOsK0cqhPrJ78GQ9qKA2AcVqNCvsJIrYaRqYtRLyvQlYSyHIZ13CJ12eao/z/PZ4Q1fTrYQnGDk3oIHlVAZnCimKPAQ99MAukBCeb/J+1ZncsVNyrKaZa8J9dB01/+PIkF5hPE5455EEOTJMxDJQfHatsAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217747; c=relaxed/simple;
	bh=I9xhHCfEOF88XcKHvgSJ8eBNQmZ9pe+CR784W/KsUMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ep/fSlGnDq5UGD8DNCbyNu1vZFqqKojdJ3kAk9J/EIyYyu2bTYsHibz5xUTy8FlDqKqvhrbcg88bagFboZLHMLq0cJepXMIK/ozUSaVWZIinuwMu2oKpYJ75683v6RtRN96iwADSpohfe8Hx1ntm18L58xNCn/f6g/pF4kTAPdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOdSKcpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOdSKcpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E986EC4CEF1;
	Tue, 26 Aug 2025 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217747;
	bh=I9xhHCfEOF88XcKHvgSJ8eBNQmZ9pe+CR784W/KsUMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOdSKcpEXyzNpCnkl/1LGAA7jjSI6rXx7qguZBvBd/DAjmu/ZAR89L+gFykNszV35
	 q5uNkLy5i7pY2/mFRLUosw6uQOwIEYSS3isLaR+iHWILf6iIHI1bjIz+Ehm0/hOoGx
	 3Iv8Cbg+G/T6v8Ie+sHWqcvsDzYw2tKAYu6fhMYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"John Warthog9 Hawley" <warthog9@kernel.org>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/523] ktest.pl: Prevent recursion of default variable options
Date: Tue, 26 Aug 2025 13:07:49 +0200
Message-ID: <20250826110930.813306982@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8ac30e2ac3ac..512a3cc586fd 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1291,7 +1291,10 @@ sub __eval_option {
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



