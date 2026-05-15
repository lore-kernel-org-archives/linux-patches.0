Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C993FF1AD;
	Fri, 15 May 2026 16:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860916; cv=none; b=OD7WxwOQhiF8UaiE1o6FWrDV7mfORJZFKVpIAx4FhNferm9u+IbHpG/mXBQGvwPeSKELuucgnEtzfFtgGhyk4K1982Xlkst7hL31F9uYKRy7fwTCVA4wiM/YuCoN8fUcPPXUyw/wDNMOm2xMYazmETA6qcgZiLqsv9CFRH42z00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860916; c=relaxed/simple;
	bh=2I2mFwUsOCkUut5C1saf/1V9EsNdqRx5m/8IfnJ9MN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYVUW+gKx2UenMYyLi2DCTRgVEsrQLTbLq5on36FnmIaEaFBb2xU8JkIyVeMYYg6tbMOcHyLIyCDhrFJuwVSSClhZeZoTglsQ28vFHjoQ/itCL2wjLU5PAjvvl+dk/YCxRopL1SSL6XG+f7zE+IA0NrGIIfXDhP2mZR9JKoAH8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAyRwKOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAyRwKOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50F2C2BCB0;
	Fri, 15 May 2026 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860916;
	bh=2I2mFwUsOCkUut5C1saf/1V9EsNdqRx5m/8IfnJ9MN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAyRwKOfxQZTrseiFBYWTMX8hns7Oi4MolNsXJQJMR7djMdikbFNJsgfNIzdV3e47
	 HUeW1YPJGvG5SUXnFEfZ3mNaGiJOQqYT55++3hJpWr+Pk4EZ6IRdd47YiqQBg1ZzzY
	 VvyJf62jvtkdYtLvFNC1amyGE30QZHjbO5CaNIJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Warthog9 Hawley <warthog9@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 129/474] ktest: Fix the month in the name of the failure directory
Date: Fri, 15 May 2026 17:43:58 +0200
Message-ID: <20260515154717.824240037@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

commit 768059ede35f197575a38b10797b52402d9d4d2f upstream.

The Perl localtime() function returns the month starting at 0 not 1. This
caused the date produced to create the directory for saving files of a
failed run to have the month off by one.

  machine-test-useconfig-fail-20260314073628

The above happened in April, not March. The correct name should have been:

  machine-test-useconfig-fail-20260414073628

This was somewhat confusing.

Cc: stable@vger.kernel.org
Cc: John 'Warthog9' Hawley <warthog9@kernel.org>
Link: https://patch.msgid.link/20260420142426.33ad0293@fedora
Fixes: 7faafbd69639b ("ktest: Add open and close console and start stop monitor")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1777,7 +1777,7 @@ sub save_logs {
     my ($result, $basedir) = @_;
     my @t = localtime;
     my $date = sprintf "%04d%02d%02d%02d%02d%02d",
-	1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
+	1900+$t[5],$t[4]+1,$t[3],$t[2],$t[1],$t[0];
 
     my $type = $build_type;
     if ($type =~ /useconfig/) {


