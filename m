Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6EB14A4E6;
	Tue, 20 Feb 2024 21:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464395; cv=none; b=WgBICaVLWQOwAJIf4QXv4JeT+AN1nY0fDRPsGpXwFItlR6vE/Wo54Gw6OAAJ1ygElRxt0kM8Hg4Jg0E7cPgs4aBhiVDILdr00V5UM0MhYKJgsIe108/ZWtlUS/0EbMcLYmLVpQBcaizfs/uq9VDCwR1zSaWttVRjnO2UNB8fxwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464395; c=relaxed/simple;
	bh=JizJfe9M9dfgCO0eQYaQpzc4t2sKOyjCzVlOkuvrHQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnSVc1T2W8DM1R67fEunFMABsAV82LmWY7+5u8yoAx8EeB5yYuL0f5ag+1oJtVw8urpfIvQqizBp/+Q+v2UBdkIIUhOZUHDMN7XjLCe7EFeigRGw3l8y61kACSgNXdr38k+SPTNvI0cZxS1HIIuQw9Rei/Su0+e3gE+qhPHBPf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiO7RaSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiO7RaSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E17FC433C7;
	Tue, 20 Feb 2024 21:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464395;
	bh=JizJfe9M9dfgCO0eQYaQpzc4t2sKOyjCzVlOkuvrHQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiO7RaSu6pHeed6MIhJ+ui8cMSnP8xMx3azSa9GpkLyKRB1UtOktsPp1+/Moeqxz3
	 mjc6ARL3yjQfZczNG2rLH5Ytk8uD3D0aODmBcaZBeA7EFYBbevNn5Mxhf6oMCptz8F
	 I0gLFsHlNlLkxifXpEAbMDkonTVR0ZgrERIX9ZRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 012/309] btrfs: send: return EOPNOTSUPP on unknown flags
Date: Tue, 20 Feb 2024 21:52:51 +0100
Message-ID: <20240220205633.518968451@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

commit f884a9f9e59206a2d41f265e7e403f080d10b493 upstream.

When some ioctl flags are checked we return EOPNOTSUPP, like for
BTRFS_SCRUB_SUPPORTED_FLAGS, BTRFS_SUBVOL_CREATE_ARGS_MASK or fallocate
modes. The EINVAL is supposed to be for a supported but invalid
values or combination of options. Fix that when checking send flags so
it's consistent with the rest.

CC: stable@vger.kernel.org # 4.14+
Link: https://lore.kernel.org/linux-btrfs/CAL3q7H5rryOLzp3EKq8RTbjMHMHeaJubfpsVLF6H4qJnKCUR1w@mail.gmail.com/
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -8111,7 +8111,7 @@ long btrfs_ioctl_send(struct inode *inod
 	}
 
 	if (arg->flags & ~BTRFS_SEND_FLAG_MASK) {
-		ret = -EINVAL;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 


