Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D395380F;
	Mon, 11 Dec 2023 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFygRZe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1865DC433BD;
	Mon, 11 Dec 2023 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319563;
	bh=yW1qp/bUmAjM28kQHNqbyts1ZUE/Lvbn8VFpLtTLuaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFygRZe6+fRZBEHuksBtAa54LFe35gbHS5i45BPOdK4BvPR1rJzxe2XU/ivA/t5aR
	 QvjcXdQWCMcUOALoDU2LqSW14lgvam1e5XCUo9c+veKSIfepal7QvzdAXkom8djOZp
	 EaqG5jY9HueD7jXtEBZk0wIdloZeAWSBQ5A3Ayvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Maninder Singh <maninder1.s@samsung.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Vaneet Narang <v.narang@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 152/244] checkstack: fix printed address
Date: Mon, 11 Dec 2023 19:20:45 +0100
Message-ID: <20231211182052.640063890@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Heiko Carstens <hca@linux.ibm.com>

commit ee34db3f271cea4d4252048617919c2caafe698b upstream.

All addresses printed by checkstack have an extra incorrect 0 appended at
the end.

This was introduced with commit 677f1410e058 ("scripts/checkstack.pl: don't
display $dre as different entity"): since then the address is taken from
the line which contains the function name, instead of the line which
contains stack consumption. E.g. on s390:

0000000000100a30 <do_one_initcall>:
...
  100a44:       e3 f0 ff 70 ff 71       lay     %r15,-144(%r15)

So the used regex which matches spaces and hexadecimal numbers to extract
an address now matches a different substring. Subsequently replacing spaces
with 0 appends a zero at the and, instead of replacing leading spaces.

Fix this by using the proper regex, and simplify the code a bit.

Link: https://lkml.kernel.org/r/20231120183719.2188479-2-hca@linux.ibm.com
Fixes: 677f1410e058 ("scripts/checkstack.pl: don't display $dre as different entity")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vaneet Narang <v.narang@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/checkstack.pl |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -139,15 +139,11 @@ $total_size = 0;
 while (my $line = <STDIN>) {
 	if ($line =~ m/$funcre/) {
 		$func = $1;
-		next if $line !~ m/^($xs*)/;
+		next if $line !~ m/^($x*)/;
 		if ($total_size > $min_stack) {
 			push @stack, "$intro$total_size\n";
 		}
-
-		$addr = $1;
-		$addr =~ s/ /0/g;
-		$addr = "0x$addr";
-
+		$addr = "0x$1";
 		$intro = "$addr $func [$file]:";
 		my $padlen = 56 - length($intro);
 		while ($padlen > 0) {


