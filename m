Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222997C
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 01:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0239C433C8;
	Thu, 27 Jul 2023 01:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690421173;
	bh=if7mzj0ehLrHlgt0FgMdKCzlq6hqghMUjN16hVUhVM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ar7csIzQfRs9zXZqq0NCp1cuwNpYNmhrdE2AH8tqnXWLoyvzcFgU0qHMhiKQYpHa+
	 +CaOIRsVu46Sb2dLfYX9TXHvAo/e2MXs3LAEkUmKVsdnSBOYCRtjxE/FGjVXtr10Tf
	 6creTx5kKdaOSgCq2IPka5Hsq1+vks0wibV+Unyi5dkYIbkcIdPHbscqbaQBCnvhc5
	 1E/LgntaOerIjuPPwkuOoOjRPONuTJk4031afPIY/2vSml+7LB2txsRVN614k9AfZl
	 wCzentE2XxjsemndmXKVrkx9BqjIpiQ7aHjl2J7V1wkgklxbqfg0gvPOcHrMvEv8uQ
	 ESvg3+eRgw/QQ==
Date: Wed, 26 Jul 2023 18:26:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Zorro Lang <zlang@redhat.com>,
	fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] fstests: add helper to canonicalize devices used to
 enable persistent disks
Message-ID: <20230727012613.GD11377@frogsfrogsfrogs>
References: <20230720061727.2363548-1-mcgrof@kernel.org>
 <20230725081307.xydlwjdl4lq3ts3m@zlang-mailbox>
 <20230725155439.GF11340@frogsfrogsfrogs>
 <20230726044132.GA30264@mit.edu>
 <ZMFJp5OZN3vnT/yI@bombadil.infradead.org>
 <20230727011330.GE30264@mit.edu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727011330.GE30264@mit.edu>

On Wed, Jul 26, 2023 at 09:13:30PM -0400, Theodore Ts'o wrote:
> On Wed, Jul 26, 2023 at 09:28:23AM -0700, Luis Chamberlain wrote:
> > > I'm a little confused.  Where are these "sanity checks" enforced?
> > > I've been using
> > > 
> > > SCRATCH_DEV=/dev/mapper/xt-vdc
> > > 
> > > where /dev/mapper/xt-vdc is a symlink to /dev/dm-4 (or some such)
> > > without any problems.  So I don't quite understand why we need to
> > > canonicalize devices?
> > 
> > That might work, but try using /dev/disk/by-id/ stuff, that'll bust. So
> > to keep existing expecations by fstests, it's needed.
> 
> What goes wrong, and why?  /dev/disk/by-id/<disk-id> is a symlink,
> just like /dev/mapper/<vg>-<lv> is a symlink.
> 
> What am I missing?

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt
# TEST_DIR=/mnt TEST_DEV=/dev/sda FSTYP=xfs ./check generic/110
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 flax-mtr01 6.5.0-rc3-djwx #rc3 SMP PREEMPT_DYNAMIC Wed Jul 26 14:26:48 PDT 2023

generic/110        2s
Ran: generic/110
Passed all 1 tests

versus:

# TEST_DIR=/mnt TEST_DEV=/dev/disk/by-id/scsi-0QEMU_RAMDISK_drive-scsi0-0-0-0 FSTYP=xfs ./check generic/110
mount: /mnt: /dev/sda already mounted on /mnt.
common/rc: retrying test device mount with external set
mount: /mnt: /dev/sda already mounted on /mnt.
common/rc: could not mount /dev/disk/by-id/scsi-0QEMU_RAMDISK_drive-scsi0-0-0-0 on /mnt
# umount /mnt
# TEST_DIR=/mnt TEST_DEV=/dev/disk/by-id/scsi-0QEMU_RAMDISK_drive-scsi0-0-0-0 FSTYP=xfs ./check generic/110
TEST_DEV=/dev/disk/by-id/scsi-0QEMU_RAMDISK_drive-scsi0-0-0-0 is mounted but not on TEST_DIR=/mnt - aborting
Already mounted result:
/dev/sda /mnt

(This is not really how I run fstests, it's just the minimum example.)

--D

> Thanks,
> 
> 						- Ted
> 
