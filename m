Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B27A265CC2;
	Tue, 25 Mar 2025 12:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905599; cv=none; b=i3M1DzKaC2oAveQ5Nt7DJFH44rA5YwXk4GibK4o6qV+5AExzvywBDrLnU5LO2JfbkG7pfV4+pIvzY5OtcL7EIf89SFhJqUoptX0NbYYHEDt+7DgvCm8G+ZS6er+78BpvDZl+pRL1WCP5odrH7cjrfMfzxEdxdGrzrdAmzZJvres=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905599; c=relaxed/simple;
	bh=R5/4zO8BrQm6OPD9ukT3qY8xml9i0VClIg/CCfpvVK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IixsmLisygCX1JvvsGyyRQRa/5aQq3p1XR63ls/9asOPbyHW4nMzocLKM3rsXjgY0tizsXEt1nIGieKe1wqQDh4+0n2lliNi47F+8MWB14yiHK3/1t+Aj2NEnrm5UEAQU3WpQAYrjgZr1uQ7MtEWsVeDbHgy0XyEjCYJ/233SQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2hryCbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2hryCbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CF7C4CEEE;
	Tue, 25 Mar 2025 12:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905598;
	bh=R5/4zO8BrQm6OPD9ukT3qY8xml9i0VClIg/CCfpvVK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2hryCbDVVYG6jb4VpZII7QnpUxsoaxQnaOXEWZIVaogF5S73c0mImzYjoKF/rR8K
	 HUPJjHSXRDUbuqRX3QGPI8kvui/EG6Uc480P4JDdA0d6AucNU6OHlAChIsjuEQaNP9
	 6lE5FRKkNz39TfapR8ryur/qitfwY91hGFIr2F5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/198] sctp: Fix undefined behavior in left shift operation
Date: Tue, 25 Mar 2025 08:20:23 -0400
Message-ID: <20250325122158.241873490@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit 606572eb22c1786a3957d24307f5760bb058ca19 ]

According to the C11 standard (ISO/IEC 9899:2011, 6.5.7):
"If E1 has a signed type and E1 x 2^E2 is not representable in the result
type, the behavior is undefined."

Shifting 1 << 31 causes signed integer overflow, which leads to undefined
behavior.

Fix this by explicitly using '1U << 31' to ensure the shift operates on
an unsigned type, avoiding undefined behavior.

Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Link: https://patch.msgid.link/20250218081217.3468369-1-eleanor15x@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index ee6514af830f7..0527728aee986 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -735,7 +735,7 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 	 *     value SHOULD be the smallest TSN not acknowledged by the
 	 *     receiver of the request plus 2^31.
 	 */
-	init_tsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map) + (1 << 31);
+	init_tsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map) + (1U << 31);
 	sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
 			 init_tsn, GFP_ATOMIC);
 
-- 
2.39.5



