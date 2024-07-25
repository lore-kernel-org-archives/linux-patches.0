Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF6419A29C;
	Thu, 25 Jul 2024 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918366; cv=none; b=pcLGJOjCaBx4d8ED4dDmnHiKIZgQvgRX1ZS7b++molZE/+l/Q84xxa9TbfdZaCfxb/wix7f5k11O95j+WP++KQm4ntyOlyQ+dseOwxIWHV/Zx/Xk3QgGH6qCcNvUrPlBl6j6oc/3t9dSmIHsjEy1MMyHs0n9wp1eA9zqP9F6Ieo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918366; c=relaxed/simple;
	bh=SVB5c5EltdIVhsEg0v7eJ1/D3AhUtnnRcw70cYTvWnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOrGbVszyHah5FQ7Og+XEaIb21Lu7fSsG9E/5aMH5EYOw050pOdXjl0RbP3mgwF15s7By2/gCtKBJ4qRxItOvE5S2MQsT7tFi8exKXkGp2Sw8lYvFZif+0f6JpcJNQex6KKpcOewzvUEZ/9oE+kv3eir3lRoszfpRje3Zy4PsRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKum2qo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKum2qo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB2EC116B1;
	Thu, 25 Jul 2024 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918366;
	bh=SVB5c5EltdIVhsEg0v7eJ1/D3AhUtnnRcw70cYTvWnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKum2qo67XsjjdxmowW0dJ72OlQO1UiIm3PfU+L1IoofZ0yGSqAqeLyvE4Z89R0QJ
	 662rPHbPhbuxFU6w6pSpnv84MWiwxEBeqPVvG8NXd8KgRILlswzNi0n3CeS+9g+AGu
	 75SpYI41BbmVWxydUXOcNDqrj3eWJDBum0bdRv6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.10 06/29] fs/ntfs3: Validate ff offset
Date: Thu, 25 Jul 2024 16:36:22 +0200
Message-ID: <20240725142732.058337344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

From: lei lu <llfamsec@gmail.com>

commit 50c47879650b4c97836a0086632b3a2e300b0f06 upstream.

This adds sanity checks for ff offset. There is a check
on rt->first_free at first, but walking through by ff
without any check. If the second ff is a large offset.
We may encounter an out-of-bound read.

Signed-off-by: lei lu <llfamsec@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -724,7 +724,8 @@ static bool check_rstbl(const struct RES
 
 	if (!rsize || rsize > bytes ||
 	    rsize + sizeof(struct RESTART_TABLE) > bytes || bytes < ts ||
-	    le16_to_cpu(rt->total) > ne || ff > ts || lf > ts ||
+	    le16_to_cpu(rt->total) > ne ||
+			ff > ts - sizeof(__le32) || lf > ts - sizeof(__le32) ||
 	    (ff && ff < sizeof(struct RESTART_TABLE)) ||
 	    (lf && lf < sizeof(struct RESTART_TABLE))) {
 		return false;
@@ -754,6 +755,9 @@ static bool check_rstbl(const struct RES
 			return false;
 
 		off = le32_to_cpu(*(__le32 *)Add2Ptr(rt, off));
+
+		if (off > ts - sizeof(__le32))
+			return false;
 	}
 
 	return true;


