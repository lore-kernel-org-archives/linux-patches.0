Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B87224B1B;
	Mon, 29 Dec 2025 16:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025551; cv=none; b=WvBAg0NSisrFXnmQ68qDHDG+7ThnEbysAW/2zJYaUBVaROMimMAtC1LHdGXCUuha1yOWvEOSjjXofuuDAkUhgKqNL9kqo7FAXzkUISOOgk1Xkk63Po8bLxACch9elBltHm2/xGCSC1hOsIxTdYbY+tc+1ecwpOG+8g/DtAo2abA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025551; c=relaxed/simple;
	bh=T5rx3aVBNsCj4we/EBrMvCLlpi10TQcvX2Nu1P8rtA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6DBHShiWD+RscGZZbig6TKx930i5eRHQaE+SlVm2ZbfgBdz6UWvKkTGU7SN5aWFbMzzzFHOPr7UygmQRvbx6iqs5OL+pFIdffcwOaPMpky8BnJUFjcgI3H5osVMNJXvQ7NVMDuDUxn1CnJjUmamyH+rerVGhwFKqa7VWGfKQvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OD84D9qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OD84D9qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D76C4CEF7;
	Mon, 29 Dec 2025 16:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025551;
	bh=T5rx3aVBNsCj4we/EBrMvCLlpi10TQcvX2Nu1P8rtA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OD84D9qp+w9YBFO6glhCHtn720RN9tnyumROQxIJf1kLToQQcwCqkdzzykKyTDBeb
	 xjZVqzQEjSPwIp1tfLhTVHGjXoXetZVNIniKu+osbZJa3OQ9LrH0SsK6mSpiCB4dPv
	 Z4xG7uw33dJB0+i1OxpnBUoF5vgO/e7VcbjGcyDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Warthog9 Hawley <warthog9@kernel.org>,
	"John W. Krahn" <jwkrahn@shaw.ca>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 254/430] ktest.pl: Fix uninitialized var in config-bisect.pl
Date: Mon, 29 Dec 2025 17:10:56 +0100
Message-ID: <20251229160733.702192887@linuxfoundation.org>
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
 


