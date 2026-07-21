Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B21D401A18;
	Tue, 21 Jul 2026 17:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654419; cv=none; b=FNqIJBjxzPCL/6mfwxAodTY1QuFw4dyvlXakTWaZ/BEggUigR61ZScgrQIaU9LE1TIY1sYZ7yBbgdZVWzelcZfsmHowo9ccZ66J+2ClBE0mvSe/+xzX3BkHVtpG5DkuuWmdhE8jp0PvoCWF4caqpQCOozuRzmeO0ydtMRcpj0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654419; c=relaxed/simple;
	bh=KdUKezpQ8C47Ig8FNijy18afwm2M6XquF/mYk3WQzx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tb+g5Or9awTvYBAHvSG0Lqr2qZ6qDwINq0V4lY70eAWNk1Gm0qCv4tAZsbqXKiSb16Qn8ZaOLz3NOPw3JdSq6TJsFkjWRvjW/eDIpFlNNVZanIe/xuKcFx+MyAbNwp1x4KrkbK2IfTsSz92fsHt2D7Atso2iSqZvXZG/5cnR87k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uE/K82Z/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uE/K82Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15CF1F000E9;
	Tue, 21 Jul 2026 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654418;
	bh=b9h8eh4ZTOVPD99BbZ23tA+MBw2PBElovRzTXUEs4Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uE/K82Z/ExhjSnWnJY35PNEQizZ01fDM6ckpXCz/xCyqi+GhVNw8sIjPbHMl70ptO
	 2tBjCPrGoZPDEtZadQb/B9ePAcdJ7yOwlhXottc8O/RKCdE0MXyISRLxIcu5OM9C4p
	 Or0CHBG5HV9Lmx25OWiGc5Ln+1/ISQ4/DXIsSoco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1696/2077] ntfs: detect mapping-pairs LCN accumulator overflow
Date: Tue, 21 Jul 2026 17:22:49 +0200
Message-ID: <20260721152632.761610828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

commit ec4f061f2219e0f0c6465d56d0380bf749235a53 upstream.

The NTFS mapping-pairs parser accumulates relative LCN deltas in a
signed integer.  A corrupted attribute can drive that addition past
the representable range.

One corrupt runlist shape sets the accumulated LCN to S64_MAX and
then adds a delta of 1 in the next mapping-pairs entry.

Signed overflow is undefined and can turn an invalid runlist into a
different set of physical clusters.

Check the LCN addition for overflow before storing the next run.

Cc: stable@vger.kernel.org # v7.1
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/runlist.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index d8e8aa7b5bc0..cbb6576cf725 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -860,7 +860,11 @@ struct runlist_element *ntfs_mapping_pairs_decompress(const struct ntfs_volume *
 			for (deltaxcn = (s8)buf[b--]; b > b2; b--)
 				deltaxcn = (deltaxcn << 8) + buf[b];
 			/* Change the current lcn to its new value. */
-			lcn += deltaxcn;
+			if (unlikely(check_add_overflow(lcn, deltaxcn, &lcn))) {
+				ntfs_error(vol->sb,
+						"LCN overflow in mapping pairs array.");
+				goto err_out;
+			}
 #ifdef DEBUG
 			/*
 			 * On NTFS 1.2-, apparently can have lcn == -1 to
-- 
2.55.0



