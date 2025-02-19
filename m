Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2D11C5485;
	Wed, 19 Feb 2025 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955394; cv=none; b=VOmx2aKCDxv01eajAA/MRQoIBKb56wbOd++eYetPTqVhA+6TWDIa+IBvweXEPaFc0Z3BJcdadn56abyKfUP1c4vI2/zy7BdK82DgxaQhsuggrag+RPZyrlMIcIVYUZXX55/8YDGsERsPSktvhTqZ6N4yUVuy+rIKn5IkRNM5XZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955394; c=relaxed/simple;
	bh=PdMHwQzhUyQKRcEimg/8H6END5Di+ZOLGKsQ33eX7nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSj6IxzS9s0q9jeN2zgVkDa8fWpxWOyGuAuLcSMeiO3o25bNrFU7s/lzEZlObF8yChnZgeibxr8Vhm6KFOssuM6hoZRKk7brsXxBWXCmkXY71t/7jkwmgU8wMAfOCMb7ObzSqfZQJzzDAzUMx0Bk0uZTvFMiv0svH8Tkk6oD6po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YU56ZsnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YU56ZsnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D36C4CEE6;
	Wed, 19 Feb 2025 08:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955394;
	bh=PdMHwQzhUyQKRcEimg/8H6END5Di+ZOLGKsQ33eX7nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YU56ZsnUIQo0IEYU95V0J7b/qXsz99JBOs9G1VM0eKyBTLz2WiMruUorSuyRN6Y9C
	 tsQqyV8KA3a6kN9bX92iH8B6KT3eXE3rtt1CDyKL4xxTUeWuOcETFCWRM32Lxu2UT2
	 GjoUGcMbDwrM8UvUS2+j3RnVOCA3aKApEETSfqkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@pm.me>,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH 6.12 222/230] selftests/bpf: Fix uprobe consumer test
Date: Wed, 19 Feb 2025 09:28:59 +0100
Message-ID: <20250219082610.374572362@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 4b7c05598a644782b8451e415bb56f31e5c9d3ee upstream.

With newly merged code the uprobe behaviour is slightly different
and affects uprobe consumer test.

We no longer need to check if the uprobe object is still preserved
after removing last uretprobe, because it stays as long as there's
pending/installed uretprobe instance.

This allows to run uretprobe consumers registered 'after' uprobe was
hit even if previous uretprobe got unregistered before being hit.

The uprobe object will be now removed after the last uprobe ref is
released and in such case it's held by ri->uprobe (return instance)
which is released after the uretprobe is hit.

Reported-by: Ihor Solodrai <ihor.solodrai@pm.me>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Ihor Solodrai <ihor.solodrai@pm.me>
Closes: https://lore.kernel.org/bpf/w6U8Z9fdhjnkSp2UaFaV1fGqJXvfLEtDKEUyGDkwmoruDJ_AgF_c0FFhrkeKW18OqiP-05s9yDKiT6X-Ns-avN_ABf0dcUkXqbSJN1TQSXo=@pm.me/
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
@@ -869,21 +869,14 @@ static void consumer_test(struct uprobe_
 			fmt = "prog 0/1: uprobe";
 		} else {
 			/*
-			 * uprobe return is tricky ;-)
-			 *
 			 * to trigger uretprobe consumer, the uretprobe needs to be installed,
 			 * which means one of the 'return' uprobes was alive when probe was hit:
 			 *
 			 *   idxs: 2/3 uprobe return in 'installed' mask
-			 *
-			 * in addition if 'after' state removes everything that was installed in
-			 * 'before' state, then uprobe kernel object goes away and return uprobe
-			 * is not installed and we won't hit it even if it's in 'after' state.
 			 */
 			unsigned long had_uretprobes  = before & 0b1100; /* is uretprobe installed */
-			unsigned long probe_preserved = before & after;  /* did uprobe go away */
 
-			if (had_uretprobes && probe_preserved && test_bit(idx, after))
+			if (had_uretprobes && test_bit(idx, after))
 				val++;
 			fmt = "idx 2/3: uretprobe";
 		}


