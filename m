Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9E93DEADC;
	Mon,  4 May 2026 14:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903590; cv=none; b=LJHNLPXZGUqDfxTWGHFcZw0v4OTgs0mRm1GvOwddBjmAoLQCqiPllvshGJKvDsMKnBoq/WbCAKBBt2+pMrzCzrSsKB65H7YOSMB4dNmgJTDGF7zEM9g/lPAA9Ft2awjYsm/yD4NYoF9k7J6LZtzCL2ssY1JD+q6B17GfUL1XS1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903590; c=relaxed/simple;
	bh=AUHjMWSjTCAkWIzxEk1zaa9IeDfynRzHMcbEI71iSlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fx5Pyt+l+GbnwXi+L2T5gXKJ0yR97h/r1S8CudnRtaSqBc5D9968k+4n7Y/99fM7a6raUtEIB+FL1bN1BN5d+yl8k/pGvQIFhbyy4A5GG4Wuzslo5eVO3kdP1BICHk7UuQZDsg1w/uOv8PvLTxp52tt9CwNZSN68qDm3R1jXmEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAVyrZmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAVyrZmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679EEC2BCB8;
	Mon,  4 May 2026 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903590;
	bh=AUHjMWSjTCAkWIzxEk1zaa9IeDfynRzHMcbEI71iSlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAVyrZmNq/oz9DxTTrYuSv/D2DNSLB9ulF7wnO3EWlDU2XA6X4vah8LfAC3ZqZWUD
	 UZEJ9WnQKyirme0IekKPPIMeSPUEBr5ffqn7rZ7H+xRrM6RjlcI463MRp434EYZIo+
	 WJ8W09TLMxoYPzPFrcgP7eAecIwEbn5m9l2wmi5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Warthog9 Hawley <warthog9@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.0 276/307] ktest: Fix the month in the name of the failure directory
Date: Mon,  4 May 2026 15:52:41 +0200
Message-ID: <20260504135153.184238081@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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
@@ -1815,7 +1815,7 @@ sub save_logs {
     my ($result, $basedir) = @_;
     my @t = localtime;
     my $date = sprintf "%04d%02d%02d%02d%02d%02d",
-	1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
+	1900+$t[5],$t[4]+1,$t[3],$t[2],$t[1],$t[0];
 
     my $type = $build_type;
     if ($type =~ /useconfig/) {


