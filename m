Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEFE7C;
	Sun, 23 Jul 2023 09:17:55 +0000 (UTC)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1qNVDo-0007XV-5T; Sun, 23 Jul 2023 11:17:48 +0200
Message-ID: <9b5838ea-91ef-a758-2d32-481ee3b4345e@leemhuis.info>
Date: Sun, 23 Jul 2023 11:17:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US, de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Igor Mammedov <imammedo@redhat.com>,
 Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20230721160528.800311148@linuxfoundation.org>
 <20230721160536.293573004@linuxfoundation.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 6.4 172/292] PCI: acpiphp: Reassign resources on bridge if
 necessary
In-Reply-To: <20230721160536.293573004@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1690103876;6a299dc8;
X-HE-SMSGID: 1qNVDo-0007XV-5T

On 21.07.23 18:04, Greg Kroah-Hartman wrote:
> From: Igor Mammedov <imammedo@redhat.com>
> 
> commit 40613da52b13fb21c5566f10b287e0ca8c12c4e9 upstream.
> 
> When using ACPI PCI hotplug, hotplugging a device with large BARs may fail
> if bridge windows programmed by firmware are not large enough.
> 
> Reproducer:
>   $ qemu-kvm -monitor stdio -M q35  -m 4G \
>       -global ICH9-LPC.acpi-pci-hotplug-with-bridge-support=on \
>       -device id=rp1,pcie-root-port,bus=pcie.0,chassis=4 \
>       disk_image
> 
>  wait till linux guest boots, then hotplug device:
>    (qemu) device_add qxl,bus=rp1
> 
> [...]

Greg, just so you know, that patch (which is also queued for 6.1 and
5.15) is known to cause a regression in 6.5-rc. To quote
https://lore.kernel.org/all/11fc981c-af49-ce64-6b43-3e282728bd1a@gmail.com/

```
Laptop shows a kernel crash trace after a first suspend to ram, on a
second attempt to suspend it becomes frozen solid. This is 100%
repeatable with a 6.5-rc2 kernel, not happening with a 6.4 kernel - see
the attached dmesg output.

I have bisected the kernel uilds and it points to :
[40613da52b13fb21c5566f10b287e0ca8c12c4e9] PCI: acpiphp: Reassign
resources on bridge if necessary

Reversing this patch seems to fix the kernel crash problem on my laptop.
```

Ciao, Thorsten

P.S.: I only noticed this by chance and yet again wonder how to handle
these situations better. I guess exporting the list of regressions
regzbot tracks in some simple format might be a start; then the stable
scripts could simply look up commit ids there when a patch is queued and
warn if they find it (which won't help in caes the regression is
reported after the patch is queued :-/ ).
