Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C9F4F391F;
	Tue, 13 Oct 2026 11:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891989; cv=none; b=OOxijIlrEVLPu6dZfgi9Mw8zptNuE9LcjZRYEqImkLVgeSms1mFE43Fs6fxeeYmDrs3NaYZESrtO6zYfrNRoV37ikeOSrKlpxWu8NGSzHmZc30KYomVdMK5yqZF5HRdO3dMDnI5d4zW/50nsObJWrwCjCAhFUv2f7DxAvxvC8Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891989; c=relaxed/simple;
	bh=BoG2Vh4YKnzi3MnDQn7jWAh4e0xUJAAmIW6KvGotth0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUgcsAD7NutRBO06E1wkXeE+RZxyGb8LoZEOv7HO4aH9fCz8k2NxXOmBjZ84gUL+GeiO0jeuzJDTQe5ej3pQ1ezjKmZJCoZ7V0ExZsves1cY5DK6U1MT3vD2+DwBnQ3x5ODSe59CmC5LNf0aJ69RJ31fOgnng9h+7y93wYXmmx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sm1Kmlol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sm1Kmlol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B757D1F000FF;
	Tue, 13 Oct 2026 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891988;
	bh=L1ppzKPaxZ5KSKhbkhLST1UfiqAHr3zDXC26xoWYhzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sm1Kmlol7w8u3fDFMCGydcDl760yiMdfkaE8cU1flxSe5pTcUkQk9ELLMD95dR5Et
	 eorUev1z1qUK9oBCVoR45Jmfjmw30wFlB+XKoPvTE96Erx0wQcEqtNsgT6zJlKROSa
	 /SXq3xu66Cq64f3yAV9cYrgtGJtYjcWtztsV92JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.2 023/281] btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()
Date: Tue, 13 Oct 2026 13:35:39 +0200
Message-ID: <20261013112855.613202654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 1fd742c7479961da6d0bb794ef8ac6b7b9442847 upstream.

When paths_from_inode() fails, scrub_print_warning_inode() jumps to err
without dropping the reference taken by btrfs_get_fs_root(), leaking a
reference to the root every time path resolution fails while printing
scrub warnings.  Every other error and success path of the function
drops the reference.

Drop the reference on the paths_from_inode() failure path too.

Fixes: 558540c17771 ("btrfs scrub: print paths of corrupted files")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -550,8 +550,10 @@ static int scrub_print_warning_inode(u64
 	}
 	ret = paths_from_inode(inum, ipath);
 
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * we deliberately ignore the bit ipath might have been too small to


