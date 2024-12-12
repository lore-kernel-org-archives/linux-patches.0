Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18862F44;
	Thu, 12 Dec 2024 16:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021695; cv=none; b=EhSKlCyYoX/OgrmkKmsXTP4g97sW6xJosA6IKfObBUrxc1EpZ5eTlteS0HYChhVk4b9C1E/QNQeKturnmMob6CQ5DrOe0yRMXw373nRr5Ws62bk9Woy5kh4iMKeKg92BDGjA0Qaz7f3Yw1QkYO9HIOzcrYVt4npf0uxj1vGOwwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021695; c=relaxed/simple;
	bh=lTpZy0OgEJREQbUq05MYeaxfP7oMWkf6TaxpBTIvfLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGbz98gpw6Q3MT4WVxamV9rMPe6I8xOkS5NmdbzN1+2I0msxLCoE7UVgG3NYuSgE6B3gEgjSf6RyEQn2umYtqz1UxMqUzv0/BebCu8TUQ3orCsm3oqqiIVE69lzHAlRBBCgi4OQLN0+BqVsKmzHnNcVvIsuUUtIX+nO/uBHgcBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xdv6dk6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xdv6dk6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CF4C4CECE;
	Thu, 12 Dec 2024 16:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021694;
	bh=lTpZy0OgEJREQbUq05MYeaxfP7oMWkf6TaxpBTIvfLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xdv6dk6u0b145rdpaqbTci8CAeMTWWP5UXMQ7FVc1H6BedmJEkoUN+YiCNXPwj0u/
	 Vomh8a2waQUA4zyx3FiKyAkalBu+bnUKbT+7a2RntlnwzifDz3iyA31QU9hBiN2bl6
	 53PnGjEXcXkg4S4n02OY1ssKPOvhe9VcRVgL5cQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5.15 037/565] lib/buildid: Fix build ID parsing logic
Date: Thu, 12 Dec 2024 15:53:52 +0100
Message-ID: <20241212144312.927767183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

The parse_build_id_buf does not account Elf32_Nhdr header size
when getting the build id data pointer and returns wrong build
id data as result.

This is problem only stable trees that merged 8fa2b6817a95 fix,
the upstream build id code was refactored and returns proper
build id.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Fixes: 8fa2b6817a95 ("lib/buildid: harden build ID parsing logic")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/buildid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -40,7 +40,7 @@ static int parse_build_id_buf(unsigned c
 		    name_sz == note_name_sz &&
 		    memcmp(nhdr + 1, note_name, note_name_sz) == 0 &&
 		    desc_sz > 0 && desc_sz <= BUILD_ID_SIZE_MAX) {
-			data = note_start + note_off + ALIGN(note_name_sz, 4);
+			data = note_start + note_off + sizeof(Elf32_Nhdr) + ALIGN(note_name_sz, 4);
 			memcpy(build_id, data, desc_sz);
 			memset(build_id + desc_sz, 0, BUILD_ID_SIZE_MAX - desc_sz);
 			if (size)


