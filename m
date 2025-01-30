Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B272BB15;
	Thu, 30 Jan 2025 13:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245556; cv=none; b=NkegJgS42Fwyr32nHWthfnoqM69NQ9IryywwClv/v2Zr+faJSN/fuMQDB5rWptGvU55omdceTVkOF9df2kNjCPSQoB1oiTHX3vbVZLdzUG851/BnjFahbNwXIFTm1kyRrQPYco7ZVVaAXYPfsB9esQw2gTCkuqvFVgFY/UwbRRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245556; c=relaxed/simple;
	bh=vUIM3lJDQv/iFqVLxwAY1Dr+ggO5vbhnQmF2ZN1iq0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6GPtf/NLMgcfwO5+Tbp4dFSwcOfi1zHLjpdxvvhQaE8aWrVkpQkjUUSKqnBRrcTQ9QQcJhAO4Hn8ztWLaQkUim/RJoQ8TsTQlAhkhVBojLOG5ay/JnREs3zhhkIRXnDdlYPrl8EPl7OEX9WHHhqsfjZFex2ZwPp4AzNPQqw/xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwHpRON6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwHpRON6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDAAC4CED2;
	Thu, 30 Jan 2025 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245556;
	bh=vUIM3lJDQv/iFqVLxwAY1Dr+ggO5vbhnQmF2ZN1iq0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwHpRON6xhrqqjreRBV1y9MWT06MnGC8suLdtL63H+O6fHF1fAeoqPk+znGZ7jwU5
	 skZrgBGWB5qYfhym/YGGtorkztEiaX20FCWhyg+7/IRMh+wCIORSeqf9NwSLtI+NHs
	 QR88vYaA3NhLeia3tw8sLW6cVvm7zor60pvd7MlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 6.13 01/25] gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag
Date: Thu, 30 Jan 2025 14:58:47 +0100
Message-ID: <20250130133456.976335595@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 7c9d9223802fbed4dee1ae301661bf346964c9d2 upstream.

Truncate an inode's address space when flipping the GFS2_DIF_JDATA flag:
depending on that flag, the pages in the address space will either use
buffer heads or iomap_folio_state structs, and we cannot mix the two.

Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin <jjtan24@m.fudan.edu.cn>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -251,6 +251,7 @@ static int do_gfs2_set_flags(struct inod
 		error = filemap_fdatawait(inode->i_mapping);
 		if (error)
 			goto out;
+		truncate_inode_pages(inode->i_mapping, 0);
 		if (new_flags & GFS2_DIF_JDATA)
 			gfs2_ordered_del_inode(ip);
 	}


