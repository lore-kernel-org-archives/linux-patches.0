Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAEA1C57B1;
	Tue, 15 Oct 2024 12:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993813; cv=none; b=jJmYOWbEYPQHsZhh2zjlurJHReBptuCYIaBvb88lteWjyrRzVLZOZ1GtmEuPozJL0OvmCWX4LFXrHfEbWkm6iCPs2cfZW9MIzgHJDP32191CrwmCjvd/twMhuJe0FnnhtT9CPWWE9vOwscl4X1FffmzInbAm7MGuTuLMwPhMh4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993813; c=relaxed/simple;
	bh=TUbD6d2mcc1wMd4MjCpOrfCVy8bGtrDt9zx+Iyg68R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q82+GWPlzpAXH9mxRgujpXqvtK/b1ZBbaTcDs7GghMPuWfoRij1p4pOO616vMlRrmi8K0PruRkA87I8MjjedMve6o041DVi6V1OGN+oAeZRtcGYKz1UAf31NuOptdaEVHkb75zmm3FDbKXBJRKL3RaNHHPhLe+43UxSv7wDVaks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erbizc79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erbizc79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CECC4CEC6;
	Tue, 15 Oct 2024 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993813;
	bh=TUbD6d2mcc1wMd4MjCpOrfCVy8bGtrDt9zx+Iyg68R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erbizc79VQ6CHbEhoBPFEfQB578lNFWCINbepryKeTJC5QCloLnrGgjOcshkSfBdt
	 OnFHaT35WYZ5pKfV7iOJXG43AM9PlWrpCWFsMny7ECVBx8TBmhENmBrDPFMhg2p9mY
	 cMDXQ0GYcGUvoOBnHK1Mpl37IFf6lwiSxewePxBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 516/691] ext4: mark fc as ineligible using an handle in ext4_xattr_set()
Date: Tue, 15 Oct 2024 13:27:44 +0200
Message-ID: <20241015112500.825912281@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit 04e6ce8f06d161399e5afde3df5dcfa9455b4952 upstream.

Calling ext4_fc_mark_ineligible() with a NULL handle is racy and may result
in a fast-commit being done before the filesystem is effectively marked as
ineligible.  This patch moves the call to this function so that an handle
can be used.  If a transaction fails to start, then there's not point in
trying to mark the filesystem as ineligible, and an error will eventually be
returned to user-space.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240923104909.18342-3-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2512,6 +2512,8 @@ retry:
 
 		error = ext4_xattr_set_handle(handle, inode, name_index, name,
 					      value, value_len, flags);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR,
+					handle);
 		error2 = ext4_journal_stop(handle);
 		if (error == -ENOSPC &&
 		    ext4_should_retry_alloc(sb, &retries))
@@ -2519,7 +2521,6 @@ retry:
 		if (error == 0)
 			error = error2;
 	}
-	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, NULL);
 
 	return error;
 }


