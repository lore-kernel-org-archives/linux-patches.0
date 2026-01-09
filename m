Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985AF32F748;
	Fri,  9 Jan 2026 12:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960491; cv=none; b=kiiliD6KV2NYU7DEY4qvUGk3yISRjr8afEp4X/lLuaJZrRjfC9b+8VPTAnM9O4siTGYxh7VcXTsFjR9ldHGq0PChI84sz62ZrZmLxGjPX6WnOOEVlbx+if+6uHCmerX8HNYlIMOdB5V8Ycj5gxJa/hEYJRJFtYbuyIFTsHU7L2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960491; c=relaxed/simple;
	bh=pknuLDS35zI+ch7kTUAdgNjwlL6ZP21SOBS+jnTY05A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZfSW1vTDaUTyEQDr4Jl0t0IzVYW7NV1qwDOuKX9EYAwklcXd8UjWAJCMY22PRJU1/uuSC7Rs0h59rsC823v7ZEwRZCGJb3IELZ86Evm25zHr1t48B5We2zDuyG0q4hLeSnYu9lmGvQWe8DsBqfcBi3CiqymDU4otM3OjwEtcNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9QhCzbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9QhCzbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9C6C4CEF1;
	Fri,  9 Jan 2026 12:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960491;
	bh=pknuLDS35zI+ch7kTUAdgNjwlL6ZP21SOBS+jnTY05A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9QhCzbCIzrp7KVaRiuMoxniSiTm3n9xSPL9c7PdstQaJ5qvCPh7I5uw8BsXzbFfU
	 LlH6q8vKiUaCU8RQcC2GTXrvPY7Y5qPILg1t2J0A0XbfKpsjDtYDXVN5YqUh1m3Yvv
	 DGXAR29kpRLN53YzlA34O9JsadU+gy6vy1/XA3gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Warthog9 Hawley <warthog9@kernel.org>,
	"John W. Krahn" <jwkrahn@shaw.ca>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 421/737] ktest.pl: Fix uninitialized var in config-bisect.pl
Date: Fri,  9 Jan 2026 12:39:20 +0100
Message-ID: <20260109112149.831064038@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit d3042cbe84a060b4df764eb6c5300bbe20d125ca upstream.

The error path of copying the old config used the wrong variable in the
error message:

 $ mkdir /tmp/build
 $ ./tools/testing/ktest/config-bisect.pl -b /tmp/build config-good /tmp/config-bad
 $ chmod 0 /tmp/build
 $ ./tools/testing/ktest/config-bisect.pl -b /tmp/build config-good /tmp/config-bad good
 cp /tmp/build//.config config-good.tmp ... [0 seconds] FAILED!
 Use of uninitialized value $config in concatenation (.) or string at ./tools/testing/ktest/config-bisect.pl line 744.
 failed to copy  to config-good.tmp

When it should have shown:

 failed to copy /tmp/build//.config to config-good.tmp

Cc: stable@vger.kernel.org
Cc: John 'Warthog9' Hawley <warthog9@kernel.org>
Fixes: 0f0db065999cf ("ktest: Add standalone config-bisect.pl program")
Link: https://patch.msgid.link/20251203180924.6862bd26@gandalf.local.home
Reported-by: "John W. Krahn" <jwkrahn@shaw.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/config-bisect.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/ktest/config-bisect.pl
+++ b/tools/testing/ktest/config-bisect.pl
@@ -741,9 +741,9 @@ if ($start) {
 	die "Can not find file $bad\n";
     }
     if ($val eq "good") {
-	run_command "cp $output_config $good" or die "failed to copy $config to $good\n";
+	run_command "cp $output_config $good" or die "failed to copy $output_config to $good\n";
     } elsif ($val eq "bad") {
-	run_command "cp $output_config $bad" or die "failed to copy $config to $bad\n";
+	run_command "cp $output_config $bad" or die "failed to copy $output_config to $bad\n";
     }
 }
 


