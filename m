Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCCA341ABD;
	Tue, 26 Aug 2025 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216250; cv=none; b=dV/j4yFHJ6XChaTF/wYxyQbJ1WE7852TJK9saLzHYhNSMX6Vua2u9e9uS6x9YJajqqe+m13N+I9XQaJ0HogJU6KtVf3JAsWJ8ij/h++NcysZ3vA6VGGzuwKrwB/hqZKI8iK6BA9VAqj/uNGDvyanA/ontVUS5W9uWf4dH/bNurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216250; c=relaxed/simple;
	bh=VFVxXr9Jj7Hq5oNy0C4vBCfr+Xfa2ckvTqH4yNRTfdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKTWQOwu7Q7qAXZ8Tkyyu8B4MUMp9LSkYcg8Z5PkmDq8QkhaC+GYnn402M0ZCLUf+t0y+YPSrIaV476prpxYO1m5DLTRm4VzuDKNQ+K9UHkTw9M3LbdMkGpeFlAB54qgANK1VNOiqpuksgVjkwasZM0mLV43NgAbrMNb4zp3oss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPpxFXgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPpxFXgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60D2C4CEF1;
	Tue, 26 Aug 2025 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216250;
	bh=VFVxXr9Jj7Hq5oNy0C4vBCfr+Xfa2ckvTqH4yNRTfdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPpxFXgXDetxW4Lq5VOElfw8kC72eDks8HCJEUmw2amRSHjEYBI2/91OG7C6pedHd
	 SVbkJVTOjTl4MGeIsx7iz1mFxL4IL5auVS9KlMiOoznmRAlACkxuWRlgx/o/YfxDLO
	 OHYjmDYaqS60NcmixqWMaAwZJ10LSJ6oKJLrWAa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"John Warthog9 Hawley" <warthog9@kernel.org>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/644] ktest.pl: Prevent recursion of default variable options
Date: Tue, 26 Aug 2025 13:07:09 +0200
Message-ID: <20250826110954.763242493@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2109bd42c144..26544bba3f8f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1351,7 +1351,10 @@ sub __eval_option {
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



