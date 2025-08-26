Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7A3350D72;
	Tue, 26 Aug 2025 14:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218981; cv=none; b=bWwf3pelLQTII0ZCQ5aY0yRbHhMOa0L6RsOmyqM8kxKwpiG2e6oWnYs0j20llTvBCes0xi5Ew83D+nJeiCLXqL7+C3YpwlgMk7vNKSIXif+e9aqYBqNVti41KgBcJ8KTfVrY2jI6ORSjhFD4DnhCfYy/IvoXYhEMuQag0LYfdb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218981; c=relaxed/simple;
	bh=qmOdCx2+wp0jBvP/mS5mNOoGlUMwFLDdoZqvYsSPkik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPF+5XIYbCGdBvfTd6xZG1zxtudFZGcZ8ZK5LD5tXlN+B+zRyiFHTK0avKBDY+URXgO04DsdWLCL3lt7oeFWaNTKZdJnGFQg5VfIC1QZCkmruQSYa1u44wL68g1Pka+b7ZWfkjLuTbN8Ud7Hs5qV9fZUxEmDYY2gcdfJB0qC7xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6n5NfWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6n5NfWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16DFC4CEF1;
	Tue, 26 Aug 2025 14:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218980;
	bh=qmOdCx2+wp0jBvP/mS5mNOoGlUMwFLDdoZqvYsSPkik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6n5NfWjTLw3xLX/Rj6bkIpBRuVuOj3gfb1eRdfQuA7N8s7ryTpVDZHK5ufu5bqQT
	 K6nHbKaj2hkhD+PGQZFfBKdnttE77fKMuW8tn81U5ELEntOy/UW0bM97o/Skyi5/+J
	 x76guX2FQ3ZuIYz5JSSlmm87vB0CoVArx40ua+V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"John Warthog9 Hawley" <warthog9@kernel.org>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/403] ktest.pl: Prevent recursion of default variable options
Date: Tue, 26 Aug 2025 13:08:52 +0200
Message-ID: <20250826110912.538637809@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 10b3c5b25b69..964a531e1a65 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1280,7 +1280,10 @@ sub __eval_option {
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



