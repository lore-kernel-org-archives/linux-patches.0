Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7820347AC
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWrEfNug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B14CC433CC;
	Mon,  9 Oct 2023 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859674;
	bh=85I0nDnbOwDCqJb0R9zE9W13VPrXR1DlQR6dObkIS7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWrEfNug8jvbkD62KjE6aQk2o5LH6pFK0KNAv4IFKDb6qwFXjQW1TI0fZkYnPbKgt
	 vktFDyuG++M1HoIfnQirptVsu7RmieZD3NjlLsgr0FzjA0IbBDKpKZS1l6BYK3U0b6
	 j81vKeCwzMLt07XYbY0vbp8D8C4xVw6I0GsMiSI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 70/91] btrfs: reject unknown mount options early
Date: Mon,  9 Oct 2023 15:06:42 +0200
Message-ID: <20231009130113.943075052@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -991,6 +991,10 @@ static int btrfs_parse_subvol_options(co
 		case Opt_subvolrootid:
 			pr_warn("BTRFS: 'subvolrootid' mount option is deprecated and has no effect\n");
 			break;
+		case Opt_err:
+			btrfs_err(NULL, "unrecognized mount option '%s'", p);
+			error = -EINVAL;
+			goto out;
 		default:
 			break;
 		}


