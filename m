Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DC627700
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3nvUUuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A409FC433C9;
	Mon,  9 Oct 2023 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859137;
	bh=IIEvWm92lfoPLPeW0bh01ZSNBYEywe31Ikfwa+elcaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3nvUUuEw0ayyi4ocFAxW5CPH8RTZz8tRigSteNLVzfqf6JaIX9IUVqp4ssinS5Cj
	 0u3+5W5IXvGS5X8tV0hA9WZp68IppWfGjftGYKGsmZsgygRdGOCndhVlvZtU59LtbF
	 6gKCb8cj5PppxgaR9VVgGu3ROhkh6TdkfXiCNb5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 183/226] btrfs: reject unknown mount options early
Date: Mon,  9 Oct 2023 15:02:24 +0200
Message-ID: <20231009130131.413264622@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 5f521494cc73520ffac18ede0758883b9aedd018 upstream.

[BUG]
The following script would allow invalid mount options to be specified
(although such invalid options would just be ignored):

  # mkfs.btrfs -f $dev
  # mount $dev $mnt1		<<< Successful mount expected
  # mount $dev $mnt2 -o junk	<<< Failed mount expected
  # echo $?
  0

[CAUSE]
For the 2nd mount, since the fs is already mounted, we won't go through
open_ctree() thus no btrfs_parse_options(), but only through
btrfs_parse_subvol_options().

However we do not treat unrecognized options from valid but irrelevant
options, thus those invalid options would just be ignored by
btrfs_parse_subvol_options().

[FIX]
Add the handling for Opt_err to handle invalid options and error out,
while still ignore other valid options inside btrfs_parse_subvol_options().

Reported-by: Anand Jain <anand.jain@oracle.com>
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1123,6 +1123,10 @@ static int btrfs_parse_subvol_options(co
 
 			*subvol_objectid = subvolid;
 			break;
+		case Opt_err:
+			btrfs_err(NULL, "unrecognized mount option '%s'", p);
+			error = -EINVAL;
+			goto out;
 		default:
 			break;
 		}


