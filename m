Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F12A33E9;
	Fri, 24 Nov 2023 19:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2zmUf36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA71C433C8;
	Fri, 24 Nov 2023 19:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852481;
	bh=JrFZfy6ZYHD3HO3yVKBq6rLXS/ahc3kY1aiqI7xumHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2zmUf369fwYMUv/Div18Pu/6h9478Ow10Ip0evRekeT7COM74mYYdoAzzDLdV/Ug
	 3k1uMSdBQb9FcP2s7/0N9HyC/ONC0JJ30JTjqJczzTYCVXkBV2KoYMpu1rMg0UE049
	 qPrFzsnDMAXxdxkSxlmovpwURMZHv6ofZITS+l2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 353/372] ext4: correct the start block of counting reserved clusters
Date: Fri, 24 Nov 2023 17:52:20 +0000
Message-ID: <20231124172022.101762710@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 40ea98396a3659062267d1fe5f99af4f7e4f05e3 upstream.

When big allocate feature is enabled, we need to count and update
reserved clusters before removing a delayed only extent_status entry.
{init|count|get}_rsvd() have already done this, but the start block
number of this counting isn't correct in the following case.

  lblk            end
   |               |
   v               v
          -------------------------
          |                       | orig_es
          -------------------------
                   ^              ^
      len1 is 0    |     len2     |

If the start block of the orig_es entry founded is bigger than lblk, we
passed lblk as start block to count_rsvd(), but the length is correct,
finally, the range to be counted is offset. This patch fix this by
passing the start blocks to 'orig_es->lblk + len1'.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20230824092619.1327976-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents_status.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1365,8 +1365,8 @@ retry:
 			}
 		}
 		if (count_reserved)
-			count_rsvd(inode, lblk, orig_es.es_len - len1 - len2,
-				   &orig_es, &rc);
+			count_rsvd(inode, orig_es.es_lblk + len1,
+				   orig_es.es_len - len1 - len2, &orig_es, &rc);
 		goto out_get_reserved;
 	}
 


