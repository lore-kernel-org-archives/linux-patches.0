Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8F82550D7;
	Wed, 25 Feb 2026 01:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983424; cv=none; b=bCLEc3YhsRBCmTsMStZ/+84gZcMwP7uLoRhMRVWyC8waH+au14QmZWEtJUa0jITLt9+FMZ2Rs60c7ieSZ2gzIadD3HiyEJ5R6mvixPZM1GH495tyCDLWmnb7F/SKrFYBfPRy1Fx8pDOf22fe7Inhz+TtKiTdVHiVL8cA/6IDDPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983424; c=relaxed/simple;
	bh=HjyI0X/jvRrv6PAHHl6ladMRKC2ilfcYsZCnpU+xyxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUp0l2NhIIJ7cYr6vx8fRle10fEUQdbX4Cdwih70KJZ6+rWEe/oOaOTqgPQn1H64w+z2S5molAspuquSoo6T14u/OFOE6uaWkVy5vIZ7z6e7itB36APCIUOrTf2nI/yKnmTrKNT2dOlzMd6BGpVDKSkhWPXjFuE1lDEUTWT9Vo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/GxO88P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/GxO88P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E08C116D0;
	Wed, 25 Feb 2026 01:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983423;
	bh=HjyI0X/jvRrv6PAHHl6ladMRKC2ilfcYsZCnpU+xyxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/GxO88PIMLRrWLOxBUOEfdZBUl9lAUiz97ia9SUj5Ls+7rbnlPhlztbfeh5xOq1U
	 RkXHhJyzZv638vV9ETlHDnXyfT+BZp+LCJgLQIh6npDegkg/mMs3g+6C0Ij6KCuCNG
	 i9WFxTq3elNmzO2ddjKc8B/AFqyc698F4rm1rVf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 544/781] clk: milbeaut: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:20:53 -0800
Message-ID: <20260225012413.139012601@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 865e63b038c446d38593ddbcc362ebb62e6ff007 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 7b45988fcf78 ("clk: milbeaut: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-milbeaut.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/clk/clk-milbeaut.c b/drivers/clk/clk-milbeaut.c
index b4f9b7143eaa6..bb94d02a76cf1 100644
--- a/drivers/clk/clk-milbeaut.c
+++ b/drivers/clk/clk-milbeaut.c
@@ -407,10 +407,7 @@ static int m10v_clk_divider_determine_rate(struct clk_hw *hw,
 		return 0;
 	}
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       divider->table, divider->width, divider->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, divider->table, divider->width, divider->flags);
 }
 
 static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.51.0



