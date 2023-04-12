Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FE62F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96165C433EF;
	Wed, 12 Apr 2023 08:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289600;
	bh=b676YNVygXNPx4p2FXBDlKhAEcUuqOftBp4wKET9x1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drZpVhjyQAvxgnJbWJZLsR6UnZ1TnC3Xr0UhFHRB7FSmxhqj2LA7Q13FIUSEG4Q/d
	 jB38iibrnaPDtGUpXU+ycGozdYf9RCDR31TYumkjV4C+FgMPmHkHVbveAqY6TgmX2s
	 OgR4LaLuL0jx+OK+82qngtYDDt8kSf4FgGEVr/RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.2 162/173] maple_tree: fix potential rcu issue
Date: Wed, 12 Apr 2023 10:34:48 +0200
Message-Id: <20230412082844.683063551@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 65be6f058b0eba98dc6c6f197ea9f62c9b6a519f upstream.

Ensure the node isn't dead after reading the node end.

Link: https://lkml.kernel.org/r/20230120162650.984577-3-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4655,13 +4655,13 @@ static inline void *mas_next_nentry(stru
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
 	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	count = ma_data_end(node, type, pivots, mas->max);
 	if (ma_dead_node(node))
 		return NULL;
 
 	if (mas->index > max)
 		return NULL;
 
-	count = ma_data_end(node, type, pivots, mas->max);
 	if (mas->offset > count)
 		return NULL;
 


