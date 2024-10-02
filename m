Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12361D220A;
	Wed,  2 Oct 2024 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878577; cv=none; b=DIlqRbnkF0VflmjFrI53UsOd7CeEDZTTJCk33PTWSgAo+hj3jQMPxiGZ9emaFHL0Q4fwC00zLhhs/Sy+Pxk6pmfaY015EGTHF7XboEtgrFgWP7jIDVHriJR/bsH5mjbJu+S+mV5w5iJs+C40Sj9Yb4NgEigQuEbJ2Yg19i+UVH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878577; c=relaxed/simple;
	bh=pgTrPGd43v/crLglMrASxRG+qXHsjk6GX4WpMPm8768=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7dl5J1hQ/2j2TksuItpF+bdUcmcP9ExoXKwW1ltYvNO3lmsWaRIigs5e4D40qfxg59gAg4F928yqqd0O3T0Oi1EMKK7+NUx1Kb5XkYyLcQYfXdmpTOdkOt7FCwWf974xs9zpKbIwK8zkiuEulE2SL97317bDyA/N+1axp8AZfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYi39wb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYi39wb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D429C4CEC2;
	Wed,  2 Oct 2024 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878577;
	bh=pgTrPGd43v/crLglMrASxRG+qXHsjk6GX4WpMPm8768=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYi39wb/e9bhl9fCrArHKP2FpamytP3uN6SMjHohMnAIlPmLaDpu3dn1SRjozB2Mu
	 dwoTjmvw+t68riO+rK1LekJ4di96X4putZL1SMgXoEJjlSAPy//M8dNOHyEF3kWIN+
	 xw9LlGeJu+XhaTN/FThAevHcyoxdU4zurykfX1/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.10 461/634] selftests/bpf: correctly move log upon successful match
Date: Wed,  2 Oct 2024 14:59:21 +0200
Message-ID: <20241002125829.298441225@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit d0a29cdb6ef95d8a175e09ab2d1334271f047e60 upstream.

Suppose log="foo bar buz" and msg->substr="bar".
In such case current match processing logic would update 'log' as
follows: log += strlen(msg->substr); -> log += 3 -> log=" bar".
However, the intent behind the 'log' update is to make it point after
the successful match, e.g. to make log=" buz" in the example above.

Fixes: 4ef5d6af4935 ("selftests/bpf: no need to track next_match_pos in struct test_loader")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240820102357.3372779-3-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_loader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -545,7 +545,7 @@ static void validate_msgs(char *log_buf,
 		if (msg->substr) {
 			match = strstr(log, msg->substr);
 			if (match)
-				log += strlen(msg->substr);
+				log = match + strlen(msg->substr);
 		} else {
 			err = regexec(&msg->regex, log, 1, reg_match, 0);
 			if (err == 0) {


