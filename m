Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66821EF0B3;
	Tue, 15 Oct 2024 12:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994393; cv=none; b=AthN0baLpF93l0zG8Nt6ZY7/BNPxuEUz+BamUQ298P0+f2niUrCOnAQr1AXvfulY0tiuqbLfSgb2FG9oZUMOzFKTzCZtiKmmx68U5w62pXgO5wg/9rX1yEnzurUkGxb0nEP1P89cnHQLhFSU4SjsULZJUyQAxE5OBYAK4nP4O58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994393; c=relaxed/simple;
	bh=wveayDTU6TdFFKfiPH0wspFrLVk9CzeKXTbQ31Rg0cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCflasPBM7tZo5riNGWLBclqz781g11PoE18Z/YPNF9AwBUKCbEHGcsfsjTlh1X3NRVHw3mhMf1UGdNBjzX44+nfe/xDmZ1vt+I7GBB3f30qfouVdCB1hk5GKk8adJfuGRI9XClYAgM58FaxhPm0BMhcVHg7lDZ9LwpdiPMQeeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uB8v3YDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uB8v3YDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5626BC4CEC6;
	Tue, 15 Oct 2024 12:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994392;
	bh=wveayDTU6TdFFKfiPH0wspFrLVk9CzeKXTbQ31Rg0cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uB8v3YDRfPsPZ7PzTTbYpX7v/f7XVOmfzw2FCPYN0+mE6CbW2WjcqUsVZZXvvnSAU
	 l4KD8C7Ep/oAlWPCiXSiC781zBI/+l66TI6U71FxuCaG2eJrsJQm0FgFTbJCz+Xg6U
	 00H31j4fIJpo9enaOIryEyFIWA04g/f/S7A2zVLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 680/691] perf test sample-parsing: Fix branch_stack entry endianness check
Date: Tue, 15 Oct 2024 13:30:28 +0200
Message-ID: <20241015112507.311153087@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

commit cb5a63feae2d963cac7b687e6598d620bed13507 upstream.

Commit 10269a2ca2b08cbd ("perf test sample-parsing: Add endian test for
struct branch_flags") broke the test case 27 (Sample parsing) on s390 on
linux-next tree:

  # perf test -Fv 27
  27: Sample parsing
  --- start ---
  parsing failed for sample_type 0x800
  ---- end ----
  Sample parsing: FAILED!
  #

The cause of the failure is a wrong #define BS_EXPECTED_BE statement in
above commit.  Correct this define and the test case runs fine.

Output After:

  # perf test -Fv 27
  27: Sample parsing                                                  :
  --- start ---
  ---- end ----
  Sample parsing: Ok
  #

Fixes: 10269a2ca2b08c ("perf test sample-parsing: Add endian test for struct branch_flags")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Tested-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
CC: Sven Schnelle <svens@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/54077e81-503e-3405-6cb0-6541eb5532cc@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/sample-parsing.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -36,7 +36,7 @@
  * These are based on the input value (213) specified
  * in branch_stack variable.
  */
-#define BS_EXPECTED_BE	0xa00d000000000000
+#define BS_EXPECTED_BE	0xa000d00000000000
 #define BS_EXPECTED_LE	0xd5000000
 #define FLAG(s)	s->branch_stack->entries[i].flags
 


